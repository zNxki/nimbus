// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	site: 'https://zNxki.github.io',
	base: '/nimbus',
	integrations: [
		starlight({
			title: '☁️ Nimbus',
			description: 'Ship your folders to Google Drive, straight from your terminal.',
			social: [
				{ icon: 'github', label: 'GitHub', href: 'https://github.com/zNxki/nimbus' },
			],
			customCss: ['./src/styles/custom.css'],
			sidebar: [
				{
					label: 'Getting Started',
					items: [
						{ label: 'Introduction', slug: 'getting-started/introduction' },
						{ label: 'Installation', slug: 'getting-started/installation' },
						{ label: 'Google Drive Setup (rclone)', slug: 'getting-started/rclone-setup' },
						{ label: 'Quick Start', slug: 'getting-started/quick-start' },
					],
				},
				{
					label: 'Guides',
					items: [
						{ label: 'Tracking Directories', slug: 'guides/tracking-directories' },
						{ label: 'Excluding Files & Folders', slug: 'guides/excludes' },
						{ label: 'Scheduling Backups', slug: 'guides/scheduling' },
						{ label: 'Restoring Backups', slug: 'guides/restoring' },
						{ label: 'Updating & Uninstalling', slug: 'guides/updating-uninstalling' },
					],
				},
				{
					label: 'Reference',
					items: [
						{ label: 'Command Reference', slug: 'reference/commands' },
						{ label: 'Configuration File', slug: 'reference/configuration' },
						{ label: 'Troubleshooting', slug: 'reference/troubleshooting' },
						{ label: 'FAQ', slug: 'reference/faq' },
					],
				},
				{
					label: 'Contributing',
					items: [
						{ label: 'How to Contribute', slug: 'contributing/how-to-contribute' },
						{ label: 'Reporting Issues', slug: 'contributing/reporting-issues' },
					],
				},
			],
		}),
	],
});
