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
  echo "$TIME Checking shoprite"
  echo "Checking shoprite"
  curl "https://shop.shoprite.com/store/${code}/reserve-timeslot-process" -H 'Connection: keep-alive' -H 'Accept: */*' -H 'Sec-Fetch-Dest: empty' -H 'X-Requested-With: XMLHttpRequest' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Origin: https://shop.shoprite.com' -H 'Sec-Fetch-Site: same-origin' -H 'Sec-Fetch-Mode: cors' -H 'Referer: https://shop.shoprite.com/store/070c334/reserve-timeslot' -H 'Accept-Language: en-US,en;q=0.9,fr;q=0.8,la;q=0.7' -H 'Cookie: screenWidth=2560; visid_incap_1942103=YfPX42dVT9acmEUBOMkrF4pqk14AAAAAQUIPAAAAAADfQjO7WRKjM+PMmyoTdWLf; nlbi_1942103=kWxYEEmTfRqdHsEgcM8BYAAAAAAIUkWeS+doUWOY1VnxFpAD; incap_ses_284_1942103=aMo+MEbuSUnl6uphgfrwA4pqk14AAAAAr19yiDogFn4YTfJxp/P2MA==; visid_incap_1939907=JdMTM+qyRmOhpotqbjTE44pqk14AAAAAQUIPAAAAAAAXYk53t4P65x1YLvHv0F1w; incap_ses_284_1939907=/dkbIrz9t19n7OphgfrwA4pqk14AAAAAI6hl1lyfqsqQakvj/PzrDA==; _ga=GA1.2.800405238.1586719372; _gid=GA1.2.1220726787.1586719372; _gcl_au=1.1.435763136.1586719372; QueueITAccepted-SDFrts345E-V3_testeventq001=EventId%3Dtesteventq001%26QueueId%3Db97e53b1-c121-4812-b414-de8db6cd39d9%26RedirectType%3Dsafetynet%26IssueTime%3D1586719372%26Hash%3Dafb088bfaca2d8c84b383266e40eb3b5dd2e744da5325f0a7b055b1f4fdf8acb; visid_incap_1940024=/DuKFYpYS526tV9lHeZLjaZqk14AAAAAQUIPAAAAAABHyl68olQdlNFwMrqSMZM4; incap_ses_284_1940024=o809My2VLB/IGuthgfrwA6Zqk14AAAAAPpm9tWk5ejxAuY13RLb/wg==; ID_EXTERNAUTH=Authenticated=False&NewReg=False&ExternalAuthProvider=; SA_M=wendy.baum@gmail.com; ScTrackerSettings={"ActiveListId":null,"ActiveListName":null,"FavoritesListId":null,"IsAllowSubstitutionsSynchronized":false,"AllowSubstitutions":"True","IsPersonalShopperNoteSynchronized":false,"PersonalShopperNote":null,"IsFrequentShopperProgramMember":true,"UserRejectedReserveTimeslotNotification":false,"ChangeOrderMode":false,"PlasticBagOption":false,"IsEmpty":false}; ASP.NET_SessionId=wzcicf1v2zd1c2ebav4im4hk; MWG_ShoppingPersonalListActiveId_CD=e8d70fac-07c5-45fd-8ab3-2189d6ad34c5; DMS_SESSION_ID=9a3b6862-2449-384c-2366-825a1911a338; SC_ANALYTICS_GLOBAL_COOKIE=6825c34f51244414b8b794bee08527dd|True; MWG_Auth_3601=Rz8Q0OsJSaBJVBIrUHvZ4Q==\C4Vfb63Pe7SetOyL/jEstcUiHUaQddMdezq/uWh3epQhhvCod7ozjpVN1O739cbY2hBHDXj38v6DuJFR6RX4TUi4JTvj8lTmMMS/OQUYVOE=; ScTrackerProfile={"Email":"wendy.baum@gmail.com","AdIdentifier":"fc1704e4-d555-40ca-8aa6-5b93d4e3fc0e","FirstName":"WENDY","LastName":"BAUM","MiddleInitial":null,"Title":null,"FrequentShopperNumber":"47105550888","OnlineShoppingStoreId":null,"PreferredStoreId":"0624283"}; screenWidth=2560; _ga=GA1.3.800405238.1586719372; _gid=GA1.3.1220726787.1586719372; MWG_GSA_S={"AuthorizationToken":"cc0b7b6b-123d-4ce8-bc39-2423c5408ee2","Secret":"f266ea4e-a1ef-4a6d-9b90-c68acd22ec13","CheckoutDeliveryAddressSetFor":"070C334","PseudoStoreId":"070C334","IsChangeOrder":false,"IsRecognizedShopper":false,"SelectedTimeslotDate":null,"StoreAlertPopupState":false,"IncludePrescription":false}; _dc_gtm_UA-97173371-1=1; _dc_gtm_UA-56824083-19=1; _dc_gtm_UA-3893611-1=1; _dc_gtm_UA-44173231-1=1; _gat_UA-84476771-18=1' --data 'ControllerName=ReserveTimeslot&FulfillmentType=Delivery' --compressed  > $tfile

  ./check_doc.rb $tfile
  ret=$?
  echo "Return value $ret"
  if [ $ret -eq 0 ]; then
    echo "$TIME Delivery slot available"
    osascript ./send.scpt 9175836590 "$TIME Delivery slot available in clark"
  fi

  TIME=`date`
  echo "$TIME Sleeping until next check"
  sleep 300
done
