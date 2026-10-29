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

create policy "Anyone can view sneakers"
  on public.sneakers for select
  using (true);

create policy "Admins can manage sneakers"
  on public.sneakers for all
  to authenticated
  using (true)
  with check (true);

create policy "Anyone can join waitlist"
  on public.waitlist for insert
  with check (true);

create policy "Admins can view waitlist"
  on public.waitlist for select
  to authenticated
  using (true);

create policy "Admins can delete waitlist entries"
  on public.waitlist for delete
  to authenticated
  using (true);

-- 4. Initial Seed Data
insert into public.sneakers (name, brand, price, description, status, image_url)
values
  (
    'Puma Mizu',
    'Puma',
    20000,
    'Puma''s most fluid sneaker collection with contrast stitching.',
    'AVAILABLE',
    'https://image.goat.com/750/attachments/product_template_pictures/images/075/174/093/original/941793_00.png'
  ),
  (
    'Nike Air Jordan',
    'Nike',
    22000,
    'The OG Air Jordans featuring retro patent leather accents.',
    'AVAILABLE',
    'https://image.goat.com/750/attachments/product_template_pictures/images/072/811/840/original/895315_00.png'
  ),
  (
    'Adidas Seddan Hussain',
    'Adidas',
    16000,
    'Be a part of seddan''s history with responsive performance cushioning.',
    'UPCOMING',
    'https://image.goat.com/750/attachments/product_template_pictures/images/054/167/625/original/719114_00.png'
  );