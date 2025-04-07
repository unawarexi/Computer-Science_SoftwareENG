## First Steps with Next.js

#### Installation:

```bash
npx create-next-app@latest my-nextjs-app
cd my-nextjs-app
npm run dev
```

This will create a new Next.js project and start the development server.

#### Creating Pages:

Create a new file in the pages/ directory to automatically create a new route.
Example: Creating about.js will automatically generate an /about route.

#### Styling Your App:

Global styles can be added in styles/globals.css.
Component-specific styles can be added using CSS Modules, such as Home.module.css.

#### Adding API Routes:

Create a file under pages/api/ to define an API route.
Example: pages/api/hello.js defines an endpoint that can be accessed via /api/hello.

#### Deploying Your App:

You can deploy your app to Vercel (the creators of Next.js) for free, with easy integration and continuous deployment.
