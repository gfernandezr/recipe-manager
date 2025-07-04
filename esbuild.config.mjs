import * as esbuild from 'esbuild'
import vuePlugin from 'esbuild-plugin-vue3'
import { execSync } from 'child_process'

const args = process.argv.slice(2)
const watch = args.includes('--watch')
const deploy = args.includes('--deploy')

// Build CSS with Tailwind
async function buildCSS() {
  const { exec } = await import('child_process');
  const { promisify } = await import('util');
  const execPromise = promisify(exec);
  
  const outputDir = 'public/assets';
  const command = `npx tailwindcss -i ./app/assets/stylesheets/application.tailwind.css -o ${outputDir}/application.css${deploy ? ' --minify' : ''} --config=./tailwind.config.js`;
  
  // Ensure output directory exists
  if (!existsSync(outputDir)) {
    mkdirSync(outputDir, { recursive: true });
  }
  
  try {
    console.log('Building CSS...');
    const { stdout, stderr } = await execPromise(command);
    if (stdout) console.log(stdout);
    if (stderr) console.error(stderr);
    console.log('Successfully built CSS');
    
    // Copy the built CSS to the public directory for direct serving
    const fs = await import('fs');
    const path = await import('path');
    const cssSource = path.join(outputDir, 'application.css');
    const cssDest = path.join('public', 'application.css');
    
    if (fs.existsSync(cssSource)) {
      await fs.promises.copyFile(cssSource, cssDest);
      console.log('Copied CSS to public/application.css');
    }
  } catch (error) {
    console.error('Failed to build CSS:', error);
    throw error;
  }
}

import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import { existsSync, mkdirSync, copyFileSync } from 'fs';

// Get the current module's directory
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Create necessary directories if they don't exist
const publicAssetsDir = join('public', 'assets');
const buildsDir = join('app', 'assets', 'builds');

const ensureDirExists = (dir) => {
  if (!existsSync(dir)) {
    mkdirSync(dir, { recursive: true });
  }
};

ensureDirExists(publicAssetsDir);
ensureDirExists(buildsDir);

const buildOptions = {
  entryPoints: ['app/javascript/application.js'],
  bundle: true,
  outdir: 'public/assets',
  publicPath: '/assets',
  loader: {
    '.js': 'jsx',
    '.vue': 'js',
    '.png': 'file',
    '.jpg': 'file',
    '.svg': 'file',
    '.css': 'css'
  },
  assetNames: '[name]',
  chunkNames: 'chunks/[name]-[hash]',
  entryNames: '[dir]/[name]',
  plugins: [
    vuePlugin({
      // Extract CSS from Vue components
      css: true,
      style: {
        // Process CSS with PostCSS
        postcss: {
          plugins: [
            await import('tailwindcss'),
            await import('autoprefixer')
          ]
        }
      }
    }),
    {
      name: 'css-handler',
      setup(build) {
        // Handle CSS imports
        build.onLoad({ filter: /\.css$/ }, async (args) => {
          const css = await import('fs').then(fs => fs.promises.readFile(args.path, 'utf8'));
          return {
            contents: css,
            loader: 'css',
          };
        });

        // Build Tailwind CSS on start
        build.onStart(async () => {
          try {
            await buildCSS();
          } catch (error) {
            console.error('Error building CSS:', error);
            process.exit(1);
          }
        });
      },
    },
  ],
  logLevel: 'info',
  sourcemap: !deploy,
  minify: deploy,
  target: 'es2020',
  format: 'esm',
  splitting: true,
  chunkNames: 'chunks/[name]-[hash]',
  treeShaking: true,
  metafile: true
}

if (watch) {
  console.log('Watching for changes...')
  const ctx = await esbuild.context(buildOptions)
  
  // Watch for changes and rebuild
  await ctx.watch()
  
  // Start a local server for HMR
  await ctx.serve({
    servedir: 'public',
    port: 3035,
    onRequest: (args) => {
      console.log(`[${args.status}] ${args.method} ${args.path}`)
    },
  }).then(server => {
    console.log(`esbuild server running at ${server.host}:${server.port}`)
  })
} else {
  // One-time build for production
  await esbuild.build(buildOptions)
  process.exit(0)
}