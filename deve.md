包名：com.aiku.super_watermark_camera
SHA1: E7:82:6E:3F:A1:F9:31:CB:40:C5:13:06:0A:12:1C:34:0B:47:FC:E3
SHA256: 67:6F:C3:26:FB:36:B3:B3:7A:42:27:88:26:5F:0D:C6:7C:61:DA:3B:CA:21:71:BC:31:83:71:A2:EC:15:11:54

Bundle ID:com.aiku.super_watermark_camera

由于高版本的java无法获取签名中的md5，所以使用命令keytool -exportcert -keystore xxx.keystore | openssl dgst -md5
md5:af5e0b822d38158e60d36e7cf84d63b4

私钥：
MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMVFb2VyZ6ezMuDR
h7R8oaILrrTQDW4ZYIKhR9v79DDJF9AXAVONNdtDgZrg24kU/2z4L6o6YWHHMYFJ
U6Aj/umwZIdPWGxLeuWlgr6t2xCTlT4JF1QxO5wT9X4Ha0WE1fF0L0ToU0DFso+H
fUQeo2Gr7dg+8QxuyhV8QAW6jJbDAgMBAAECgYEAidD1fwELC2y02b1oOh5r6UKS
Hj3PdCCEfR5hjn0Z3s9ONJEt2wonGvSxYds/ZChoPd+xpRI+IEpB+pmYs6MSHUQF
jxyQRS2xqq6CYvSQ2O7bIfXqbhXiNC++2mQU2k4hBI2XuQlUnUIl0ssv7/+NHStk
5FhyvE7tikAZkWE373kCQQDvF/K6XGaf3zOjcbHZNa/o81/Deq+QK9Zcf73YXUVX
eB0DgVryQxtWXl+Z8C/ct5gysBcThhZaQ5wnABc+CB+VAkEA0zhsPsqpw/h3BiAj
edOo9uAmvbv6HRIQfAYQDn6xNH/Q27f4H6/h2oJOFP/kEYnYSa+66TXOPmILmWMP
Mm4m9wJBAIXv63i8lHzQw5O2+ENO0Pl1hNrz2m+wLwhoQwh2z4Z9cftptnHqZ+EN
Qw7wP0+sxaT3giXcwp7UKyCp61tDn7UCQGbhysfjC0HrWn5fVShYEqr9j6FHWJKk
Y+clRNjqmQILZ/4949v7XbWDVukfo0VvsSxjLlW94ZG9TA0QlSxpPw0CQEre1Ws5
g8iyd/a1SWWP6vUNeN9pVf9nfop4yKZUqR7c3tZ2LT/WtWRT9+mR0JZQ/zZIFslu
s3G03Gf69/Ytxow=

验证码进入定时任务进行更新状态

相机裁剪的原理  --- 滤镜

相册加载的优化的问题：

 --- 
 --- 

进入页面之前，一定要加载数据，binding controller 应该在哪里加载

是不是要拼图操作中logo图片，还是特地的水印中加入logo图片

前端支付回调确定订单，支付宝的回调时间是不确定的，还是说去等几分钟，进行订单的确定

后期将flutter版本改到3.24。存在花屏的问题







alipay_sdk=alipay-sdk-java-4.38.157.ALL&app_id=9021000144612694&biz_content=%7B%22out_trade_no%22%3A%2220250221200646398919%22%2C%22total_amount%22%3A%221.00%22%2C%22subject%22%3A%22%E4%BB%85%E8%B4%AD%E4%B9%B01%E4%B8%AA%E6%9C%88%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%7D&charset=UTF-8&format=json&method=alipay.trade.app.pay&notify_url=http%3A%2F%2F192.168.1.93%3A8080%2Fapp%2Fapi%2Fpay%2Fnotify%2Ftrade&sign=Ou5yVKMqJyRFNoDdyZBV%2B5cvNihpx9fZsMnexV8TBpKZdU5w46To0weEJExBQ1Mljdkrr3Lj70yAMzQaeRzVSAXviRK4GTA%2F2xyhfdXI69feiuJB2KNoi0QsKQjnHHLMw5w59MWPk0ZLAcHFe0iEn94azc4%2Boj9761qfGNj%2FKtqnzLn9KleTuAuoO68NqDVawtQKVpAqw1kABzRrgB4L0p1aoLzkrc88E%2BQcjsTFWEo0Fyt%2BfljzoF42JDdNIPWmqFkIGGPISe6Dime9i2ti3hRw35F32iuOQbKglq0m8EkkB3PBoOM2t2cYqksVIcEFz3riGY7iU23svlMp4b6gAA%3D%3D&sign_type=RSA2&timestamp=2025-02-21+20%3A06%3A46&version=1.0

{
  "alipay_sdk": "alipay-sdk-java-4.38.157.ALL",
  "app_id": "9021000144612694",
  "biz_content": {
    "out_trade_no": "20250221200646398919",
    "total_amount": "1.00",
    "subject": "仅购买1个月",
    "product_code": "QUICK_MSECURITY_PAY"
  },
  "charset": "UTF-8",
  "format": "json",
  "method": "alipay.trade.app.pay",
  "notify_url": "http://192.168.1.93:8080/app/api/pay/notify/trade",
  "sign": "Ou5yVKMqJyRFNoDdyZBV+5cvNihpx9fZsMnexV8TBpKZdU5w46To0weEJExBQ1Mljdkrr3Lj70yAMzQaeRzVSAXviRK4GTA/2xyhfdXI69feiuJB2KNoi0QsKQjnHHLMw5w59MWPk0ZLAcHFe0iEn94azc4+oj9761qfGNj/KtqnzLn9KleTuAuoO68NqDVawtQKVpAqw1kABzRrgB4L0p1aoLzkrc88E+QcjsTFWEo0Fyt+fljzoF42JDdNIPWmqFkIGGPISe6Dime9i2ti3hRw35F32iuOQbKglq0m8EkkB3PBoOM2t2cYqksVIcEFz3riGY7iU23svlMp4b6gAA==",
  "sign_type": "RSA2",
  "timestamp": "2025-02-21 20:06:46",
  "version": "1.0"
}


缓存后水印消失了，在拍照后也消失了

我的页面中有几个按钮不能点击

品牌图是不能移动的可以选择默认位置添加：
跟随水印、手动调整、四个角

经纬度不能修改






