-- ============================================================
-- 소소상점 상품 테이블 + 상품 33개 등록
-- 사용법: Supabase 대시보드 → SQL Editor → 이 파일 내용 전체 붙여넣기 → Run
-- 여러 번 실행해도 안전합니다. (같은 상품번호는 새로 넣지 않고 내용만 갱신)
-- 원본: index.html 상품 카드 (스마트스토어 2026-09-15 엑셀 기준, 추석선물세트 제외)
-- ============================================================

-- 1) 상품 테이블
create table if not exists public.products (
  id           bigint generated always as identity primary key,
  product_no   text        not null unique,          -- 스마트스토어 상품번호
  name         text        not null,                 -- 상품명
  category     text        not null,                 -- 카테고리 (주방용품, 생활용품 ...)
  price        integer     not null check (price >= 0), -- 판매가 (원)
  image_url    text,                                 -- 대표 이미지 주소
  product_url  text,                                 -- 스마트스토어 상품 페이지 주소
  is_trend     boolean     not null default false,   -- TREND 배지
  sort_order   integer,                              -- 진열 순서 (작을수록 앞)
  is_active    boolean     not null default true,    -- 판매 중 여부 (false면 쇼핑몰에서 숨김)
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

-- 2) 보안 규칙: 누구나 '판매 중인 상품'을 볼 수만 있음 (추가 · 수정 · 삭제는 대시보드에서만)
alter table public.products enable row level security;
drop policy if exists "누구나 판매 중인 상품 조회" on public.products;
create policy "누구나 판매 중인 상품 조회" on public.products
  for select to anon, authenticated
  using (is_active);
grant select on public.products to anon, authenticated;

-- 3) 상품 33개 등록 (이미 있으면 최신 정보로 갱신)
insert into public.products
  (product_no, name, category, price, image_url, product_url, is_trend, sort_order)
values
  ('13697301655', '달걀보관함 계란트레이 3단 30구 냉장고 정리함 오토폴딩 보관날짜', '주방용품', 7900, 'https://shop-phinf.pstatic.net/20260804_210/1785811560336hcqOK_GIF/16971650967CDB889C44D1E6C80CD080_img_760.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13697301655', true, 1),
  ('13697301665', '휴대편안 500ml 접이식 보온보냉 실리콘 텀블러 BPA FREE 선물용 인쇄가능', '주방용품', 7000, 'https://shop-phinf.pstatic.net/20260805_62/1785932213094koKg1_JPEG/87876226883628623_856490976.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13697301665', true, 10),
  ('13760198589', '아코디언 접이식 휴대용 장바구니 시장가방', '생활용품', 5500, 'https://shop-phinf.pstatic.net/20260914_286/1789351540763egmrO_JPEG/55992195877920008_1438920608.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13760198589', false, 11),
  ('13751235232', '무릎담요 망토담요', '생활용품', 9500, 'https://shop-phinf.pstatic.net/20260908_64/1788838525281kFjAn_JPEG/122971388424354746_1899224817.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13751235232', false, 12),
  ('13750041872', '부드러운 기모 안감 터치 니트 장갑', '패션잡화', 4500, 'https://shop-phinf.pstatic.net/20260907_69/1788765832072C91Ia_JPEG/15639606068244589_933081185.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13750041872', false, 13),
  ('13749935220', '악세사리보관함(여행용/휴대용)', '패션잡화', 2500, 'https://shop-phinf.pstatic.net/20260907_278/1788760646291PBUYj_PNG/8230046250411494_329950320.png?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13749935220', false, 14),
  ('13742329407', '자석구름택배칼 미니커터칼 안전칼', '문구장난감', 2500, 'https://shop-phinf.pstatic.net/20260902_60/1788343038613hLKUi_JPEG/21125791609980468_1467244768.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13742329407', false, 15),
  ('13742167177', '휴대용 곰돌이 경보기', '생활용품', 4500, 'https://shop-phinf.pstatic.net/20260902_214/178833835533063JUw_JPEG/26470699870270889_598537593.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13742167177', false, 16),
  ('13697301662', '휴대편안 손잡이 스텐 텀블러 보온보냉 350ml 500ml 판촉물 사은품 인쇄', '주방용품', 9900, 'https://shop-phinf.pstatic.net/20260804_52/1785811559352wEEGQ_JPEG/17286380124B7480DC55C85D6E32F408_img_760.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13697301662', false, 17),
  ('13697301650', '초미니 키링안경 휴대용 보관 다리없는 접이식 돋보기 선물용', '생활용품', 7400, 'https://shop-phinf.pstatic.net/20260804_248/1785811559340gYYbn_JPEG/17268345871B33DFE9CA0B54E8743D5C_img_760.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13697301650', false, 18),
  ('13697301652', '싱크대물받이 실리콘패드 물튐방지 배수매트 수도꼭지물받이 물때방지 주방정리 4컬러', '주방용품', 5900, 'https://shop-phinf.pstatic.net/20260804_146/17858115595563TI26_JPEG/1745218290C36A58C970524157F2F141_img_760.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13697301652', false, 19),
  ('13728967663', '[지앤지] 가벼운 메쉬 필통 파우치', '문구장난감', 4000, 'https://shop-phinf.pstatic.net/20260821_46/1787278894007undQo_PNG/136156738938980416_1282394940.png?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13728967663', false, 20),
  ('13717674555', '여성 투명 PVC 미니파우치', '패션잡화', 2500, 'https://shop-phinf.pstatic.net/20260811_99/1786448483297b4Fv9_JPEG/120581330441648384_479305370.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13717674555', false, 21),
  ('13697301664', '투명 1000ml 대용량 눈금 계량컵 V자 입구 베이킹 요리 계량용기', '주방용품', 7990, 'https://shop-phinf.pstatic.net/20260804_228/1785811559366gB1Dr_PNG/1774189208AD6E317BCDE0A3CAF94ACA_img_760.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13697301664', false, 22),
  ('13697301659', '휴대용 리필형 배변봉투 15매 1롤 알약케이스 산책 외출 용품', '생활용품', 2000, 'https://shop-phinf.pstatic.net/20260805_285/178591306838642E3U_JPEG/6582492713703876_514538205.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13697301659', false, 23),
  ('13697301654', '디지털파우치 충전기수납케이스 USB케이블정리함 이어폰보관 휴대용 생활방수 멀티파우치', '패션잡화', 2300, 'https://shop-phinf.pstatic.net/20260804_31/17858115602938g2pJ_JPEG/16130642711CDF9B342C5E6839458926_img_760.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13697301654', false, 24),
  ('13697301663', '휴대편한 일회용 우비 남녀공용 성인용 아동용 5색상 단추형 비옷', '패션잡화', 2100, 'https://shop-phinf.pstatic.net/20260804_202/1785811560915L4Cfo_JPEG/1524126501973ABC41BB0717E8C0193D_img_760.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13697301663', false, 25),
  ('13697301658', '휴대편한 고리형 손잡이 3단 자동우산 UV 99% 차단 자동버튼', '패션잡화', 9200, 'https://shop-phinf.pstatic.net/20260804_74/1785811560179uqxGL_JPEG/17476928458C0AB2164C904C579C959C_img_760.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13697301658', false, 26),
  ('13717642678', '멀티 뽀송 수세미 거치대 2color / 싱크대 수세미홀더 정리함', '주방용품', 4900, 'https://shop-phinf.pstatic.net/20260811_221/1786448493782R33Ke_JPEG/49429596562394797_331111475.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13717642678', false, 27),
  ('13697301648', '대나무 접시정리대 도마 식기거치대 접시보관대 주방정리 대사이즈', '주방용품', 5500, 'https://shop-phinf.pstatic.net/20260706_23/1783324897998zrDsI_JPEG/117457711211929867_1384305647.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13697301648', false, 28),
  ('13719930433', '쿨 아이스 냉감 반팔 남성 티셔츠', '패션잡화', 4900, 'https://shop-phinf.pstatic.net/20260813_179/1786601436104xT4X7_JPEG/132453592927422753_361446577.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13719930433', false, 29),
  ('13697301657', '축구공 회전 먼지 거름망 1P (3색상) 필터볼 세탁기 이물질거름망', '생활용품', 2300, 'https://shop-phinf.pstatic.net/20260804_251/1785811559688sC83I_JPEG/1721891987C1DF24EFCDBB440B4A9859_img_760.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13697301657', false, 30),
  ('13697301656', '니트 로프 손가방 미니백 시즌별 활용도 높은 데일리가방', '패션잡화', 6400, 'https://shop-phinf.pstatic.net/20260804_64/1785811560529OQlsC_JPEG/17743195420FFD30BA74E6B7105C405A_img_760.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13697301656', false, 31),
  ('13725208528', '남대문 히트템, 남대문 핫템. 구슬마사지기', '생활용품', 10900, 'https://shop-phinf.pstatic.net/20260818_258/1787040537065Bqq6c_PNG/62808839100018217_1810646933.png?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13725208528', false, 32),
  ('13719930878', '남대문 히트템, 문어 괄사 마사지기', '생활용품', 2000, 'https://shop-phinf.pstatic.net/20260813_66/1786601458730cP5G6_JPEG/6024488870741543_538597878.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13719930878', false, 33),
  ('13719930756', '전자레인지용 찜기 중형 소형 세트', '주방용품', 12140, 'https://shop-phinf.pstatic.net/20260813_15/1786601445981o25vA_JPEG/77787625785656651_396150776.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13719930756', false, 34),
  ('13717674333', '가볍고 편한 국산 지압슬리퍼', '생활용품', 10230, 'https://shop-phinf.pstatic.net/20260811_239/17864507681605ANYT_JPEG/108033592125176650_602564261.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13717674333', false, 35),
  ('13702536317', '비누 크런치 슬랑이 말랑이 스퀴시 크랑이 스트레스해소 촉감놀이 슬라임', '문구장난감', 4500, 'https://shop-phinf.pstatic.net/20260828_280/1787883008995CWadd_JPEG/122015844133007689_1154963298.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13702536317', false, 36),
  ('13702516603', '큐브 치즈 크런치 슬랑이 말랑이 선물용 추천 스트레스 완화', '문구장난감', 5100, 'https://shop-phinf.pstatic.net/20260806_260/17859833116209Ll1w_JPEG/107566135500312877_1638355201.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13702516603', false, 37),
  ('13697301661', '러닝양말 발바닥두꺼운쿠션양말 발바닥통증', '패션잡화', 2400, 'https://shop-phinf.pstatic.net/20260804_67/1785811561359qtdjF_JPEG/175368433405A9EEC2537881B1C0B884_img_760.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13697301661', false, 38),
  ('13697301653', '전자레인지덮개 푸드커버28cm', '주방용품', 6000, 'https://shop-phinf.pstatic.net/20260804_2/1785811559478VAgxn_JPEG/1616487569D576684612269A12EF5A26_img_760.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13697301653', false, 39),
  ('13697301651', '세면대 수전연장 각도조절 워터탭 절수노즐 360도회전 간편설치 내경22mm 전용', '욕실용품', 11500, 'https://shop-phinf.pstatic.net/20260804_257/1785811560704deoQv_JPEG/1747898005CD2D253B8E244945F63BA7_img_760.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13697301651', false, 40),
  ('13697301649', '세라믹 라면기 손잡이 도자기 면기 국그릇 패킹뚜껑 날짜표시 전자레인지용기 2컬러', '주방용품', 12900, 'https://shop-phinf.pstatic.net/20260710_277/1783673795979CqFC6_JPEG/22017337472712651_1789113476.jpg?type=f300_300', 'https://smartstore.naver.com/sosolittlestore/products/13697301649', false, 41)
on conflict (product_no) do update set
  name        = excluded.name,
  category    = excluded.category,
  price       = excluded.price,
  image_url   = excluded.image_url,
  product_url = excluded.product_url,
  is_trend    = excluded.is_trend,
  sort_order  = excluded.sort_order,
  updated_at  = now();

-- 4) 확인: 카테고리별 상품 수
select category, count(*) as 상품수 from public.products group by category order by category;