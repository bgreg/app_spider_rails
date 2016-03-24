module WebMockStubs
  def bad_response
    %q({"IsSuccess": false,"Reason": "I don't like you","ErrorMessage": "ouch"})
  end

  def good_response
    %q({"Token":"40224","IsSuccess":true,"Reason":null,"ErrorMessage":null})
  end

  def stub_authenticate
    stub_request(
      :post,
      "http://example.com/test/AppSpiderEnterprise/rest/v1/Authentication/Login"
    ).with(
      body: {"name"=>"Sarah", "password"=>"dogs > cats"},
      headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type'=>'application/x-www-form-urlencoded',
        'Host'=>'example.com',
        'User-Agent'=>'Ruby'
      }
    ).to_return(status: 200, body: yield, headers: {})
  end

  def auth_file
    "spec/config/auth.yml"
  end

  def path_file
    "spec/config/paths.yml"
  end

  def log_file
    "logs/spec_logs.log"
  end
end

