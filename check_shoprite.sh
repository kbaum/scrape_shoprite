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
elif [ "$store" = "livingston" ]; then
  echo "String is livingston"
  code="BBA4739"
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
  curl "https://shop.shoprite.com/store/$code/reserve-timeslot-process" -H 'Connection: keep-alive' -H 'Accept: */*' -H 'Sec-Fetch-Dest: empty' -H 'X-Requested-With: XMLHttpRequest' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Origin: https://shop.shoprite.com' -H 'Sec-Fetch-Site: same-origin' -H 'Sec-Fetch-Mode: cors' -H 'Referer: https://shop.shoprite.com/store/bba4739/reserve-timeslot' -H 'Accept-Language: en-US,en;q=0.9,fr;q=0.8,la;q=0.7' -H 'Cookie: screenWidth=2560; visid_incap_1942103=YfPX42dVT9acmEUBOMkrF4pqk14AAAAAQUIPAAAAAADfQjO7WRKjM+PMmyoTdWLf; nlbi_1942103=kWxYEEmTfRqdHsEgcM8BYAAAAAAIUkWeS+doUWOY1VnxFpAD; visid_incap_1939907=JdMTM+qyRmOhpotqbjTE44pqk14AAAAAQUIPAAAAAAAXYk53t4P65x1YLvHv0F1w; _ga=GA1.2.800405238.1586719372; _gid=GA1.2.1220726787.1586719372; _gcl_au=1.1.435763136.1586719372; visid_incap_1940024=/DuKFYpYS526tV9lHeZLjaZqk14AAAAAQUIPAAAAAABHyl68olQdlNFwMrqSMZM4; SA_M=wendy.baum@gmail.com; ASP.NET_SessionId=wzcicf1v2zd1c2ebav4im4hk; MWG_ShoppingPersonalListActiveId_CD=e8d70fac-07c5-45fd-8ab3-2189d6ad34c5; DMS_SESSION_ID=9a3dfkjdfd-2449-384c-2366-825a1911a338; screenWidth=2560; _ga=GA1.3.800405238.1586719372; _gid=GA1.3.1220726787.1586719372; incap_ses_284_1942103=aXRiOBGRlB4noB5kgfrwA9wHlV4AAAAATLeeMP9D3J3ozJuofKPQiw==; incap_ses_284_1940024=Wyi6Pzg/+H+5oR5kgfrwA90HlV4AAAAA9bSihHte95m/8KQI4ql5Yg==; incap_ses_284_1939907=/5qifxJTuwiWox5kgfrwA98HlV4AAAAAOAHuoWP4LglUlw795QCl0w==; QueueITAccepted-SDFrts345E-V3_testeventq001=EventId%3Dtesteventq001%26QueueId%3Dfe6a4271-061b-4fbd-917e-1d5362fb1af7%26RedirectType%3Dsafetynet%26IssueTime%3D1586825186%26Hash%3Df6824c3f9c3f01f487efbab3b44b6a8c37f6d45024420cd3a2aac2f71e762879; SC_ANALYTICS_GLOBAL_COOKIE=54ac0bf2be8248dfb51b95f8a2ccc877|True; MWG_Auth_3601=banDpoBtlJzJpi5PgvDJBw==\tIUj2Bxe7D3JnyG5ImVDlxC6Zaf1+WqOdDiJ5S7fm8EQx0ONX3FB5qgDbLBmHdRF2+D39wdElnthheAJeYIsCqghyoFDhysQVEKDj5QCseY=; ID_EXTERNAUTH=Authenticated=False&NewReg=False&ExternalAuthProvider=; ScTrackerProfile={"FirstName":"WENDY","EmailAddress":"wendy.baum@gmail.com","FrequentShopperNumber":"47105550888","ViewPreference":"None","PreferredStoreId":"0624283","OnlineShoppingStoreId":null,"IsEmpty":false}; ScTrackerSettings={"ActiveListId":null,"ActiveListName":null,"FavoritesListId":null,"IsAllowSubstitutionsSynchronized":false,"AllowSubstitutions":"True","IsPersonalShopperNoteSynchronized":false,"PersonalShopperNote":null,"IsFrequentShopperProgramMember":true,"UserRejectedReserveTimeslotNotification":false,"ChangeOrderMode":false,"PlasticBagOption":false,"IsEmpty":false}; MWG_GSA_S={"AuthorizationToken":"fd3fdc3e-c9dd-4538-9098-fe4707b38e87","Secret":"79163133-a1ab-431a-9a82-d0327c8db1bd","CheckoutDeliveryAddressSetFor":"BBA4739","PseudoStoreId":"BBA4739","IsChangeOrder":false,"IsRecognizedShopper":false,"SelectedTimeslotDate":null,"StoreAlertPopupState":false,"IncludePrescription":false}; _dc_gtm_UA-97173371-1=1; _dc_gtm_UA-56824083-19=1; _dc_gtm_UA-3893611-1=1; _dc_gtm_UA-44173231-1=1; _gat_UA-84476771-18=1' --data 'ControllerName=ReserveTimeslot&FulfillmentType=Pickup' --compressed > $tfile
  cat $tfile
  ./check_doc.rb $tfile
  ret=$?
  echo "Return value $ret"
  if [ $ret -eq 0 ]; then
    echo "$TIME Delivery slot available in $store"
    osascript ./send.scpt 9178462691 "$TIME Delivery slot available in $store"
    osascript ./display_notification.scpt "$TIME Delivery slot available in $store" "Time slot found"
  fi

  TIME=`date`
  echo "$TIME Sleeping until next check"
  sleep 300
done
