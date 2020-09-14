import 'package:nupms_app/config/AppConfig.dart';


String DEV_URL= 'http://api.nupms.com/api/v1/';

String LIVE_URL='http://api.nupms.com/api/v1/';

String SANDBOX_URL='http://api.nupms.com/api/v1/';

Map<String,dynamic> urls = {
  'login' : 'login',
//  'user-verified' : 'register/verified',
//  'find-by-imei': "register/client/{imei}",
//  'chart-accounts-by-btype':'chart-accounts/business-type/{btype}',
//  'chart-account-by-code': 'chart-accounts/bycode/{code}',
//  'chart-account-new':'chart-accounts/new',
//  'sync-data':'sync/data',
//  'sync-download-imei':'sync/download/{imei}',
//  'max-accCode-by-code':'chart-accounts/max-acc-code/{code}'
};

String getApiUrl(String route,{dynamic paramValue}){

    Env env = AppConfig.getEnv();
    String url = (env==Env.Dev)? DEV_URL : ((env==Env.SandBox)? SANDBOX_URL:LIVE_URL);

    List<String> segments = route.split("-");

    urls.forEach((key, value) {

      if(key.contains(route)) {
        AppConfig.log(route+" "+key);
        if(paramValue != null) {
          url += value.toString().replaceAll(
              "{" + segments.last + "}", paramValue);
        }else{
          url += value;
        }

      }
    });

    return url;

}