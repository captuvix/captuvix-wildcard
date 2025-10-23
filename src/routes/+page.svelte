<script lang="ts">
  import { onMount } from 'svelte';

  // State for the countdown timer
  let countdown = $state(10);
  let timerRunning = $state(true);
  let timerInterval: ReturnType<typeof setInterval> | null = $state(null);
  let subdomain = $state('');

  onMount(() => {
    // Extract subdomain from hostname
    const hostname = window.location.hostname;
    const parts = hostname.split('.');

    if (parts.length >= 2 && !['www', 'localhost'].includes(parts[0])) {
      subdomain = parts[0];
    }

    // Start countdown
    startCountdown();

    // Cleanup on unmount
    return () => {
      if (timerInterval) {
        clearInterval(timerInterval);
      }
    };
  });

  function startCountdown() {
    timerRunning = true;
    countdown = 10;

    timerInterval = setInterval(() => {
      countdown--;

      if (countdown <= 0) {
        stopCountdown();
        // Navigate to main site when countdown reaches 0
        redirectToMainSite();
      }
    }, 1000);
  }

  function stopCountdown() {
    timerRunning = false;
    if (timerInterval) {
      clearInterval(timerInterval);
      timerInterval = null;
    }
  }

  function redirectToMainSite() {
    const protocol = window.location.protocol;
    const parts = window.location.hostname.split('.');
    // Remove the subdomain and keep the main domain
    const mainDomain = parts.slice(1).join('.');
    window.location.href = `${protocol}//${mainDomain}`;
  }

  function tryAgain() {
    stopCountdown();
    window.location.reload();
  }
</script>

<div class="min-h-screen flex items-center justify-center bg-gray-50 p-6">
  <div class="bg-white flex items-center justify-center p-8 rounded-lg border border-gray-200 shadow-md max-w-md w-full">
    <div class="text-center">
      <div class="mx-auto flex items-center justify-center mb-6">
        <div class="relative">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-16 w-16 text-gray-300" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
          </svg>
          <div class="absolute -top-1 -right-1 bg-red-500 rounded-full p-1">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
            </svg>
          </div>
        </div>
      </div>

      <h1 class="text-3xl font-extrabold text-gray-900 mb-2">
        Subdomain Not Found
      </h1>

      {#if subdomain}
        <p class="text-lg text-gray-600 mb-2">
          We couldn't find an organization with the subdomain <span class="font-semibold text-blue-600">{subdomain}</span>.
        </p>
      {:else}
        <p class="text-lg text-gray-600 mb-2">
          We couldn't find this organization.
        </p>
      {/if}

      <p class="text-sm text-gray-500 mb-6">
        This could be due to a typo in the URL, the organization no longer exists, or you may not have permission to access it.
      </p>

      {#if timerRunning}
        <div class="mb-6">
          <p class="text-sm text-gray-500">
            Redirecting to main site in <span class="font-medium text-green-600">{countdown}</span> seconds...
          </p>
        </div>
      {/if}

      <div class="flex flex-col sm:flex-row gap-3 justify-center">
        <button
          onclick={redirectToMainSite}
          class="inline-flex items-center px-4 py-2 border border-transparent text-base font-medium rounded-md shadow-sm text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
          </svg>
          Go to Main Site
        </button>

        <button
          onclick={tryAgain}
          class="inline-flex items-center px-4 py-2 border border-gray-300 text-base font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
          </svg>
          Try Again
        </button>
      </div>
    </div>
  </div>
</div>
