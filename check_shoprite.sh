#!/bin/bash

store=$1

if [ "$store" = "garwood" ]; then
  echo "Store is garwood"
  code="DD7D719"
elif [ "$store" = "clark" ]; then
  echo "Strings is clark"
  code="070C334"
elif [ "$store" = "union" ]; then
  echo "Strings is union"
  code="41C8123737"
else
  echo "Pass store"
  exit 1
fi

echo "Store code ${code}"

while true
do
  tfile=$(mktemp /tmp/shoprite.XXXXXXXXX)
  TIME=`date`
  echo "$TIME Checking shoprite $store"
  curl "https://shop.shoprite.com/store/$code/reserve-timeslot-process" -H 'Connection: keep-alive' -H 'Accept: */*' -H 'Sec-Fetch-Dest: empty' -H 'X-Requested-With: XMLHttpRequest' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Origin: https://shop.shoprite.com' -H 'Sec-Fetch-Site: same-origin' -H 'Sec-Fetch-Mode: cors' -H 'Referer: https://shop.shoprite.com/store/070c334/reserve-timeslot' -H 'Accept-Language: en-US,en;q=0.9,fr;q=0.8,la;q=0.7' -H 'Cookie: screenWidth=2560; visid_incap_1942103=YfPX42dVT9acmEUBOMkrF4pqk14AAAAAQUIPAAAAAADfQjO7WRKjM+PMmyoTdWLf; nlbi_1942103=kWxYEEmTfRqdHsEgcM8BYAAAAAAIUkWeS+doUWOY1VnxFpAD; visid_incap_1939907=JdMTM+qyRmOhpotqbjTE44pqk14AAAAAQUIPAAAAAAAXYk53t4P65x1YLvHv0F1w; incap_ses_284_1939907=/dkbIrz9t19n7OphgfrwA4pqk14AAAAAI6hl1lyfqsqQakvj/PzrDA==; _ga=GA1.2.800405238.1586719372; _gid=GA1.2.1220726787.1586719372; _gcl_au=1.1.435763136.1586719372; visid_incap_1940024=/DuKFYpYS526tV9lHeZLjaZqk14AAAAAQUIPAAAAAABHyl68olQdlNFwMrqSMZM4; SA_M=wendy.baum@gmail.com; ASP.NET_SessionId=wzcicf1v2zd1c2ebav4im4hk; MWG_ShoppingPersonalListActiveId_CD=e8d70fac-07c5-45fd-8ab3-2189d6ad34c5; DMS_SESSION_ID=9a3b6862-2449-384c-2366-825a1911a338; SC_ANALYTICS_GLOBAL_COOKIE=6825c34f51244414b8b794bee08527dd|True; screenWidth=2560; _ga=GA1.3.800405238.1586719372; _gid=GA1.3.1220726787.1586719372; MWG_Auth_3601=ChDC8qc/0FqAiJX2e2CZZA==\GxuaPwNjZF54nosBpvCgWTro0uEGIBqzaNWsfV4JbkPhiOJy4aFdB3nl6i4xOLi0bAV3LFC8i/RgGZ/6xNLCJlvFtT+K+L138pNqrfNV3Ts=; ID_EXTERNAUTH=Authenticated=False&NewReg=False&ExternalAuthProvider=; incap_ses_284_1940024=+s22NmL2VwXrrttigfrwA1hUlF4AAAAArnnmO20FWCHmOdtqAvQ3Cw==; ScTrackerProfile={"FirstName":"WENDY","EmailAddress":"wendy.baum@gmail.com","FrequentShopperNumber":"47105550888","ViewPreference":"Grid","PreferredStoreId":"0624283","OnlineShoppingStoreId":null,"IsEmpty":false}; ScTrackerSettings={"ActiveListId":null,"ActiveListName":null,"FavoritesListId":null,"IsAllowSubstitutionsSynchronized":false,"AllowSubstitutions":"True","IsPersonalShopperNoteSynchronized":false,"PersonalShopperNote":null,"IsFrequentShopperProgramMember":true,"UserRejectedReserveTimeslotNotification":true,"ChangeOrderMode":false,"PlasticBagOption":false,"IsEmpty":false}; QueueITAccepted-SDFrts345E-V3_testeventq001=EventId%3Dtesteventq001%26QueueId%3D56a9a3df-a8db-4805-a747-bec33435ba68%26RedirectType%3Dsafetynet%26IssueTime%3D1586779229%26Hash%3D0e7a9411cf10b0e98fcd839ba4277bd7103a388d6a32b04b20dacb0b2ebf1855; incap_ses_284_1942103=XB2laBcwTgOlSNxigfrwA+BUlF4AAAAA17fZG7+MrplxRlvp5l5mWQ==; _dc_gtm_UA-97173371-1=1; _dc_gtm_UA-56824083-19=1; _dc_gtm_UA-3893611-1=1; _dc_gtm_UA-44173231-1=1; _gat_UA-84476771-18=1; _gat_UA-97173371-1=1; _gat_UA-56824083-6=1; _gat_UA-3893611-1=1; _gat_UA-44173231-1=1; MWG_GSA_S={"AuthorizationToken":"d7207c0d-9509-4923-9b89-bf48e6689f78","Secret":"a864a9c9-fbb3-4c5b-9628-1b8055355d0e","CheckoutDeliveryAddressSetFor":"070C334","PseudoStoreId":"070C334","IsChangeOrder":false,"IsRecognizedShopper":false,"SelectedTimeslotDate":null,"StoreAlertPopupState":false,"IncludePrescription":false}' --data 'ControllerName=ReserveTimeslot&FulfillmentType=Pickup' --compressed > $tfile
  cat $tfile
  ./check_doc.rb $tfile
  ret=$?
  echo "Return value $ret"
  if [ $ret -eq 0 ]; then
    echo "$TIME Delivery slot available in $store"
    osascript ./send.scpt 9175836590 "$TIME Delivery slot available in $store"
    osascript ./display_notification.scpt "$TIME Delivery slot available in $store" "Time slot found"
  fi

  TIME=`date`
  echo "$TIME Sleeping until next check"
  sleep 300
done
