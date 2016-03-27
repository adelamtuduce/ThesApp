Rails.application.config.middleware.use OmniAuth::Builder do
  provider :wsfed,
    :realm => "http://adelamaria13yahoo.onmicrosoft.com/192.168.1.106:3000",
    :reply => "http://localhost:3000/auth/wsfed/callback",
    :id_claim => "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name",
    :issuer => "https://login.microsoftonline.com/9dfcaefc-2a83-414a-ab8c-f1e02ed163db/",
    :issuer_name => "https://login.microsoftonline.com/9dfcaefc-2a83-414a-ab8c-f1e02ed163db/",
    :idp_cert_fingerprint => "32:70:BF:55:97:00:4D:F3:39:A4:E6:22:24:73:1B:6B:D8:28:10:A6"
end