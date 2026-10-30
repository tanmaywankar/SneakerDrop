# SneakerDrop

A fast, responsive sneaker showcase and drop platform I built for the Web Development practical assignment.

The goal was to build a basic but complete premium sneaker store with both frontend and backend, it needed to load its data in realtime from the backend server and feel premium. It also needed to have a full working admin panel with full CRUD features and a waitlist modal along with waitlist user table.

---

## Project Links

- **Live Site**: [https://sneakerdrop-dxs.pages.dev/](https://sneakerdrop-dxs.pages.dev/)
- **GitHub Repo**: [https://github.com/tanmaywankar/SneakerDrop](https://github.com/tanmaywankar/SneakerDrop)

---

## Project Overview

Sneaker retail websites often feel generic and cluttered with heavy e-commerce bloat. For SneakerDrop, I wanted to take inspiration from brutalist streetwear editorial layouts—high-contrast typography, crisp product framing, intentional micro-interactions, and instant snappy page loads.

Behind the frontend, everything is wired to a real **Supabase (PostgreSQL)** backend with **Row-Level Security (RLS)** policies in place so unauthorized users cannot tamper with product inventory or leak waitlist subscribers.

---

## Features

### Storefront & Landing Experience
- **Editorial Hero Section**: Built with responsive art direction. On desktop, a right-anchored 16:9 hero image preserves its natural proportions with a seamless true-black (`#000000`) fade on wide viewports. On mobile, it switches to a vertical stack so the sneaker image is never cropped awkwardly.
- **Custom Streetwear Typography**: Combined three distinct typefaces—`Newake` for punchy display headers, `Cal Sans` for geometric accents and labels, and `Satoshi` for readable body copy.
- **Dynamic Product Grid**: Displays real drops queried live from Supabase. Zero hardcoded mock arrays.
- **Neo-Brutalist Micro-Interactions**: Custom offset stroke hover effects and active click press states that feel tactile on both desktop and mobile touchscreens.
- **Zero-Shift Skeleton Loaders**: Placeholder skeleton cards match the exact dimensions of loaded cards.

### Drop Waitlist System
- **Early-Access Modal**: Visitors can click "Join Waitlist" on upcoming drops or "Notify" on sold-out drops.
- **Form & Input Validation**: Validates emails natively via HTML5 and with client-side checks before dispatch.
- **Database Duplicate Prevention**: Enforces a PostgreSQL composite unique constraint (`UNIQUE (sneaker_id, email)`). If someone tries submitting the same email twice for the same sneaker drop, the app intercepts error code `23505` and tells them they're already on the list.

### Protected Admin Console (`/admin`)
- **Real Supabase Auth**: Backed by email/password session authentication. Unauthenticated users are stopped by Vue Router navigation guards (`beforeEach`) and redirected to `/admin/login`.
- **Full Inventory CRUD**:
  - Add new drops with direct image URL previews.
  - Edit drop details, pricing, and live inventory status (`AVAILABLE`, `UPCOMING`, `SOLD OUT`).
  - Delete drops with cascading cleanup of associated waitlist records.
- **Waitlist Submissions Table**: Inspect who registered, which shoe they signed up for (via SQL foreign key joins), and when they joined.

---

## Screenshots

### Storefront Experience
| Desktop Product Collection | Waitlist Modal |
|:---:|:---:|
| ![Homepage Cards](/public/screenshots/HomepageCards.png) | ![Waitlist Modal](/public/screenshots/waitlistModal.png) |

| Mobile Responsive Storefront | Mobile Product Cards |
|:---:|:---:|
| ![Android Admin & Nav](/public/screenshots/AndroidAdmin.png) | ![Android Cards](/public/screenshots/AndroidCards.png) |

### Admin Management Console
| Admin Login | Drops Management Table |
|:---:|:---:|
| ![Admin Login](/public/screenshots/AdminLogin.png) | ![Admin Drops Table](/public/screenshots/AdminCard.png) |

| Waitlist Submissions Viewer |
|:---:|
| ![Admin Waitlist](/public/screenshots/AdminWaitlist.png) |

---

## Technology Stack & Decisions

| Layer | Choice | Why I Chose It |
|---|---|---|
| **Frontend Framework** | **Vue 3 (Composition API + `<script setup>`)** | Offers great reactivity without unnecessary boilerplate. Vue's SFC structure keeps template, styling, and script logic clean and readable. |
| **Styling** | **Tailwind CSS v4** | Utilized Tailwind's new `@theme` CSS variable tokens to cleanly define the brand color palette (`--color-brand-volt`, `--color-brand-black`, etc.) directly in CSS. |
| **Database & Auth** | **Supabase (PostgreSQL)** | Combines a managed Postgres database, auth system, and Row Level Security (RLS) policies without having to maintain a dedicated server. |
| **Routing** | **Vue Router 4** | Clean client-side SPA routing with auth navigation guards and route-level lazy loading for admin pages. |
| **Hosting** | **Cloudflare Pages** | Global edge network with zero cold starts, paired with `_redirects` for smooth client-side SPA routing. |

---

## Architecture & Technical Decisions

### 1. Database-Enforced Security (RLS)
Instead of relying only on client-side route guards (which can be bypassed by inspecting network requests), the supabase database itself protects the data using PostgreSQL Row Level Security (RLS):
- Anyone (anonymous visitors) has `SELECT` permission on public sneakers and `INSERT` permission on the waitlist.
- Only authenticated users (`to authenticated`) are granted permissions to `INSERT`, `UPDATE`, or `DELETE` sneakers, or `SELECT` waitlist subscribers.

### 2. Code Splitting & Performance
The admin dashboard and login views are loaded lazily via dynamic imports (`() => import(...)`). Storefront visitors only download the lightweight customer bundle (~95 kB gzipped), keeping initial page loads super fast.

### 3. SPA Refresh Handling on Cloudflare Pages
Because Vue Router uses HTML5 history mode (`createWebHistory()`), directly accessing `/admin` or refreshing the browser would normally return a Cloudflare 404. I added a `public/_redirects` file (`/* /index.html 200`) so Cloudflare always rewrites requests back to the single-page entry point.

---

## Database Setup & Schema

If you're cloning this project, run this SQL script in your Supabase SQL Editor to set up the tables, constraints, and RLS policies:

```sql
-- 1. Create Sneakers Table
create table public.sneakers (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  brand text not null,
  price numeric not null,
  description text not null,
  status text not null check (status in ('AVAILABLE', 'UPCOMING', 'SOLD OUT')) default 'AVAILABLE',
  image_url text not null,
  created_at timestamptz default timezone('utc'::text, now()) not null
);

-- 2. Create Waitlist Table with Duplicate Prevention
create table public.waitlist (
  id uuid primary key default gen_random_uuid(),
  sneaker_id uuid not null references public.sneakers(id) on delete cascade,
  email text not null,
  created_at timestamptz default timezone('utc'::text, now()) not null,
  constraint unique_sneaker_email unique (sneaker_id, email)
);

-- 3. Row Level Security (RLS)
alter table public.sneakers enable row level security;
alter table public.waitlist enable row level security;

-- Public read access for drops
create policy "Anyone can view sneakers"
  on public.sneakers for select
  using (true);

-- Admin-only full management on drops
create policy "Admins can manage sneakers"
  on public.sneakers for all
  to authenticated
  using (true)
  with check (true);

-- Public can sign up for the waitlist
create policy "Anyone can join waitlist"
  on public.waitlist for insert
  with check (true);

-- Admin-only access to view waitlist entries
create policy "Admins can view waitlist"
  on public.waitlist for select
  to authenticated
  using (true);

-- Admin-only access to delete waitlist entries
create policy "Admins can delete waitlist entries"
  on public.waitlist for delete
  to authenticated
  using (true);

-- 4. Initial Seed Data (Optional)
insert into public.sneakers (name, brand, price, description, status, image_url)
values
  ('Puma Mizu', 'Puma', 20000, 'Puma''s most fluid sneaker collection with contrast stitching.', 'AVAILABLE', 'https://image.goat.com/750/attachments/product_template_pictures/images/075/174/093/original/941793_00.png'),
  ('Nike Air Jordan', 'Nike', 22000, 'The OG Air Jordans featuring retro patent leather accents.', 'AVAILABLE', 'https://image.goat.com/750/attachments/product_template_pictures/images/072/811/840/original/895315_00.png'),
  ('Adidas Seddan Hussain', 'Adidas', 16000, 'Responsive performance cushioning built for daily wear.', 'UPCOMING', 'https://image.goat.com/750/attachments/product_template_pictures/images/054/167/625/original/719114_00.png');
```

---

## Setup & Local Development Instructions

### Prerequisites
- Node.js
- npm or pnpm
- A Supabase account

### 1. Clone & Install
```bash
git clone https://github.com/tanmaywankar/SneakerDrop.git
cd SneakerDrop
npm install
```

### 2. Configure Environment Variables
Create a `.env` file in the root folder with your Supabase credentials:

```env
VITE_SUPABASE_URL=https://your-project-ref.supabase.co
VITE_SUPABASE_PUBLISHABLE_KEY=your-supabase-anon-key
```

*(You can copy `example.env` as a reference).*

### 3. Run Development Server
```bash
npm run dev
```
Open [http://localhost:5173](http://localhost:5173) in your browser.

### 4. Build for Production
```bash
npm run build
npm run preview
```

---

## Known Limitations & Future Improvements

1. **Direct Image URL vs File Upload**: The admin drop form currently takes direct image URLs. In a future iteration, integrating Supabase Storage buckets directly with drag-and-drop file uploading and auto-compression would provide a better admin workflow.
2. **Automated Email Dispatch**: Waitlist submissions are recorded with duplicate prevention and displayed in the admin console. Hooking this up to an automated email service (like Resend or Postmark) to send real transactional drop notifications would be the natural next step.
3. **Cart Checkout**: The storefront focuses on showcase and waitlists; cart buttons is currently completely abscent as a result even though the items themselves have add to cart buttons, which was a design choice I noticed in every premium website.

---

### Admin Demo Access
- **Email**: `admin@sneakerdrop.internal`
- **Password**: `SDAdmin4096`

---
## Author

**Tanmay Wankar**  
