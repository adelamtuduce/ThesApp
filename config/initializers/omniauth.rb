Rails.application.config.middleware.use OmniAuth::Builder do
  provider :wsfed,
    :issuer_name           => "http://adfs.example.com/adfs/services/trust",
    :issuer                => "https://adfs.example.com/adfs/ls/",
    :realm                 => "https://myapp.com",
    :reply                 => "https://myapp.com/auth/wsfed/callback",
    :saml_version          => "1",
    :id_claim              => "upn",
    :idp_cert_fingerprint  => "2ds.........."
end