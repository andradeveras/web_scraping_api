require "test_helper"

class ScrapingControllerTest < ActionDispatch::IntegrationTest
  test "should get scrape" do
    get scraping_scrape_url
    assert_response :success
  end
end
