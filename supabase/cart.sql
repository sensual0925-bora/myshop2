-- ============================================================
-- 소소상점 회원 장바구니 테이블
-- 로그인한 회원의 장바구니를 저장 (비회원 장바구니는 브라우저에만 저장)
-- 여러 번 실행해도 안전합니다.
-- ============================================================

-- 1) 장바구니 테이블: 회원 1명 × 상품 1개 = 한 줄
create table if not exists public.cart_items (
  id          bigint      generated always as identity primary key,
  user_id     uuid        not null default auth.uid()
                          references auth.users (id) on delete cascade,        -- 회원 (탈퇴하면 장바구니도 삭제)
  product_no  text        not null
                          references public.products (product_no) on delete cascade, -- 상품번호
  qty         integer     not null default 1 check (qty between 1 and 99),   -- 수량
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  unique (user_id, product_no)
);

-- 2) 수정할 때마다 updated_at 자동 갱신
create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists cart_items_set_updated_at on public.cart_items;
create trigger cart_items_set_updated_at
  before update on public.cart_items
  for each row execute function public.set_updated_at();

-- 3) 보안 규칙: 로그인한 회원은 '자기 장바구니'만 보고 · 담고 · 고치고 · 지울 수 있음
alter table public.cart_items enable row level security;

drop policy if exists "내 장바구니 조회" on public.cart_items;
drop policy if exists "내 장바구니 담기" on public.cart_items;
drop policy if exists "내 장바구니 수정" on public.cart_items;
drop policy if exists "내 장바구니 삭제" on public.cart_items;

create policy "내 장바구니 조회" on public.cart_items
  for select to authenticated
  using ((select auth.uid()) = user_id);

create policy "내 장바구니 담기" on public.cart_items
  for insert to authenticated
  with check ((select auth.uid()) = user_id);

create policy "내 장바구니 수정" on public.cart_items
  for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "내 장바구니 삭제" on public.cart_items
  for delete to authenticated
  using ((select auth.uid()) = user_id);

-- 비회원(anon)은 장바구니 테이블에 접근 불가
revoke all on public.cart_items from anon;
grant select, insert, update, delete on public.cart_items to authenticated;
