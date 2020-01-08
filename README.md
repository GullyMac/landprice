# Seoul Land Price
Seoul's (Seoul, South Korea) Land Prices Prediction

Entire Report : https://github.com/GullyMac/seoul_realestate_price/blob/master/report.pdf

200118 last edit

---

## 0. Introduction

There are many features that determine land price.

In particular, since 'home prices' is very sensitive issue in Korean society,
the interest in features that determine land price is always hot.

For example, recently, Gangseo-gu (in Seoul, South Korea) has been in conflict with parents of students with disabilities, 
arguing that residents opposing the construction of special schools lower land prices and housing prices.

Therefore, the distribution of major facilities and infrastructure 
(such as special schools, large hospitals, bar or pub, lodging houses, and large supermarkets) 
are selected as potential variables that can affect land prices.

We tested whether those variables are actually related to land prices.

In addition, we tried to predict land prices using various machine learning algorithms 
and make a prediction model with small errors.

---

## 1. Data Set

#### Response Variable : 2017년 서울특별시 법정동별 개별공시지가

* Source

  서울 열린데이터 광장 - 서울시 개별공시지가 정보 (https://data.seoul.go.kr/openinf/fileview.jsp?infId=OA-1180)
  
  
* Definition

  개별공시지가는 표준지공시지가를 이용하여 산정한 개별토지의 단위면적당 가격이다.
  
  국토교통부장관은 매년 전국의 토지 중 대표성이 높은 표준지를 선정하고, 단위면적(m2)당 적정가격인 표준지공시지가를 결정하며 시장·군수·구청장은 표준지의 공시지가를 바탕으로 하여 개별토지의 단위면적당 적정가격인 개별공시지가를 산정한다.
  
  개별공시지가는 개별토지의 용도(주거용, 상업용, 공업용 등), 도로·교통조건, 토지이용규제사항 등을 유사한 이용가치를 가진 표준지와 비교하여 토지가격비준표에 의해 산출된 가격배율에 표준지공시지가를 곱하여 산정된다.
  
  
* Preprocessing
  
  단위면적당 가격이기 때문에 같은 법정동 내에 여러 건의 토지 가격 정보가 포함되어 있었다.
  
  따라서 행정구와 법정동을 기준으로 평균을 내어 해당 구 또는 동의 지가를 계산하였다.
  
  
#### Explanatory Variable : 동별 대형마트, 특수학교, 대형병원, 유흥·단란주점, 숙박업소, 학교 개수

* Source

  서울 열린데이터 광장
  
* Preprocessing

  업체 주소 자료로부터 행정구역 정보(자치구명, 법정동명)를 추출하였다.
  
  주소 자료에 법정동명이 아닌 행정동명이 입력되어있는 경우 법정동명으로 변경하였다. 
  
  결측값의 경우 직접 네이버 주소검색을 이용하여 행정구역 정보를 추출하여 채워넣었다. 
  
  법정동별로 해당하는 자료의 개수에 대한 빈도표를 작성하였으며, 분석에는 이 빈도 데이터를 사용하였다.
  
  (법정동: 옛 지명 등에서 유래된 이름을 사용하여 법으로 정한 동으로 모든 정부 기관의 공무나 재산권 및 권리행사 등의 법률행위에 사용되는 동. 변동이 거의 없다.
  
  행정동: 행정 운영의 편의를 위하여 설정한 행정구역으로 도시의 확장, 인구의 이동 등 지역여건 변화와 주민 수의 증감에 따라 수시로 설치 또는 폐지할 수 있는 동)
  
  현재 서울특별시에는 총 25개 구, 467개의 법정동이 존재하며, 이름이 같은 동이 서로 다른 구에 있는 경우가 두 가지 존재하므로 (신사동: 강남구, 은평구 / 신정동: 양천구, 마포구) 같은 값으로 처리되지 않도록 구분하였다.


* Data Specificities
  
  유흥주점과 단란주점은 법적으로는 구분되어 있으나 이번 분석에서는 구별할 필요가 없으므로 ’유흥업소’라는 상위 카테고리로 묶어서 고려하였다.
  
  유흥업소, 대형마트, 숙박업소 등은 폐업한 업소도 데이터셋에 포함되어 있으므로 현재 영업 중인 곳만 추출하여 사용하였다.
  
  대형마트 데이터는 법적으로 매장 면적이 3000m^2 이상인 대형마트와 아울렛, 백화점 목록이다. 
  
  이 중 목록 안에 있더라도 식료품이나 의류, 생활용품을 종합적으로 판매하지 않는 곳은 삭제하였다. (예: 세운상가 등 전자상가 삭제, GS슈퍼 등 의류매장이 없는 슈퍼형 마트 삭제)
  
  또한 각 대형마트 홈페이지에 명시되어 있는 점포 개수와 비교하여 목록에 없는 경우 추가하였다.
  
  마트와 백화점이 붙어있는 경우 각각 따로 집계하였다.
  
  아울렛 내에 있는 식료품매장이 따로 목록에 있는 경우 아울렛에 포함하여 하나로 집계하였다.
  
  당초 계획에서는 녹지 및 공원도 설명변수로 사용하려 하였으나 녹지, 공원의 면적이 천차만별이기 때문에 법정동별 개수로 활용하는 것은 합리적이지 못하다고 판단하였다.
  
  더불어 그 용도나 관리 실태 또한 다양하기 때문에 법정동별 면적으로 활용하는 것도 합리적이지 못하다고 판단하였다. 따라서 녹지, 공원 변수는 설명변수 목록에서 제외하였다.


* Data Transformation 
  
  숙박업소, 유흥업소, 학교의 경우 동별 개수 데이터가 동별 면적의 영향을 받을 것이므로 해당 법정동의 면적으로 나누어 1km^2당 개수로 변환하였다.
  
  newDat$yuheung <- newDat$yuheung / newDat$landsize
  
  newDat$sukbak <- newDat$sukbak / newDat$landsize
  
  newDat$school <- newDat$school / newDat$landsize
  
  1m^2당 개수이므로 10^6을 곱하여 1km^2당 개수로 변환
  
  newDat$yuheung <- newDat$yuheung * 10^6
  
  newDat$sukbak <- newDat$sukbak * 10^6
  
  newDat$school <- newDat$school * 10^6
  
  대형마트, 대형병원, 특수학교의 경우 기본적으로 전체 업체 수가 적고 좁은 구역에 집중되어 있는 경향이 있으므로 0 또는 1의 바이너리 변수로 변환하였다.
  
  "특수학교 존재하는 동 비율: 0.0556745182012848"
  
  "학교 존재하는 동 비율: 0.488222698072805"
  
  "병원 존재하는 동 비율: 0.113490364025696"
  
  "대형마트 존재하는 동 비율: 0.139186295503212"
  
  "숙박업소 존재하는 동 비율: 0.644539614561028"
  
  "유흥업소 존재하는 동 비율: 0.627408993576017"
  
  1 이상 값의 비율이 매우 낮은 특수학교, 병원, 대형마트만 binary variable로 변환
  
  for (i in 1:nrow(newDat)) {
    if (newDat$specialsch[i] >= 1) {
      newDat$specialsch[i] <- 1
    } else newDat$specialsch[i] <- 0
  }
  
  for (i in 1:nrow(newDat)) {
    if (newDat$hospital[i] >= 1) {
      newDat$hospital[i] <- 1
    } else newDat$hospital[i] <- 0
  }
  
  for (i in 1:nrow(newDat)) {
    if (newDat$store[i] >= 1) {
      newDat$store[i] <- 1
    } else newDat$store[i] <- 0
  }

