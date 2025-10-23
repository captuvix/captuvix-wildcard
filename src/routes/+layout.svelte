<script lang="ts">
	import '../app.css';
	import favicon from '$lib/assets/favicon.svg';
	import { onMount } from 'svelte';

	let { children } = $props();
	let pageTitle = $state('Subdomain Not Found');
	let subdomain = $state('');

	onMount(() => {
		// Extract subdomain from hostname
		const hostname = window.location.hostname;
		const parts = hostname.split('.');

		if (parts.length >= 2 && !['www', 'localhost'].includes(parts[0])) {
			subdomain = parts[0];
			pageTitle = `${subdomain} - Organization Not Found`;
		}
	});
</script>

<svelte:head>
	<title>{pageTitle} | Captuvix</title>
	<link rel="icon" href={favicon} />
	<meta name="description" content="Organization not found. This subdomain may be incorrect or the organization no longer exists." />
</svelte:head>

{@render children?.()}
