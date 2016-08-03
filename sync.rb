require "json"
require "pp"

require "selenium-webdriver"

require "test/unit"
require "mechanize"

class TestT < Test::Unit::TestCase

  ACCOUNT_FILE = './cache/jianshu.account'
  COOKIE_FILE = './cache/jianshu.cookie'


  HEXO_POST_PATH = './source/_posts'
  HEXO_IMAGE_PATH = './source/images'

  BASE_URL = "http://www.jianshu.com"

  def setup
    @client = Mechanize.new
  end

  def test_suite
    sync
  end


  def sync
    articles = get_articles


    #同步jianshu文章到hexo 草稿目录
    articles.each do |a|
      id = a['id']

      head = "---\ntitle: #{a['title']}\ndate: #{a['create_time']}\ntags:\n    - #{a['tag']}\n---"
      file = HEXO_POST_PATH + '/jianshu_' + (id.to_s)+ '.md'

      content = head + "\n" + a['content']
      File.write file, content

      p "post #{a['title']} synced.file:#{file}"

    end
  end

  def get_notebooks
    map = {}
    notebooks= getJSON '/writer/notebooks'

    notebooks.each do |n|

      map[n['id']] = n['name']
    end
    map
  end


  def get_articles


    articles= getJSON '/writer/notes'


    notebooks = get_notebooks


    articles.map do |a|
      id = a['id']


      a['content'] = get_article_content id


      a['tag'] = notebooks[a['notebook_id']]
      a['create_time'] = Time.strptime (Time.at(a['last_compiled_at']).to_s),'%F %T'

    end

    articles

  end



  def get_article_content id

    data = getJSON '/writer/notes/' + (id.to_s) + '/content'

    content =  data['content']

     content.to_s.match /(http:\/\/upload-images.*?)(\?.*?)([")])/ do |m|
       filename =   File.basename m[1]

       pathname = HEXO_IMAGE_PATH+'/'+filename

        image_url = m[1]+m[2]

       p 'downloading '+image_url+'...'

       @client.download image_url,pathname until File.exists? pathname


       content.gsub! m[0],"/images/#{filename}#{m[3]}"

     end
     content
  end



  def getJSON uri
    login if !read_cookie
    res = @client.get BASE_URL+uri
    if (res.body.include? '/users/password/new') #检测是否cookie已过期
      login
      res = @client.get BASE_URL+uri
    end
    JSON.parse res.body
  end

  def login
    @driver = Selenium::WebDriver.for :firefox
    @driver.manage.timeouts.implicit_wait = 30

    account= File.read(ACCOUNT_FILE).split(/ /)
    username = account[0]
    password = account[1]

    @driver.get(BASE_URL + "/sign_in")
    @driver.find_element(:id, "sign_in_name").clear
    @driver.find_element(:id, "sign_in_name").send_keys username
    @driver.find_element(:id, "sign_in_password").clear
    @driver.find_element(:id, "sign_in_password").send_keys password

    #等待1000秒直到滑动验证码被验证成功,点击登录
    wait = Selenium::WebDriver::Wait.new(:timeout => 1000)
    wait.until { @driver.find_element(:class_name, "gt_ajax_tip").attribute('class').include? 'success' }
    @driver.find_element(:class_name, 'ladda-button').click

    save_cookie
    @driver.quit
  end



  def save_cookie

    cookies = @driver.manage.all_cookies

    cookies.each do |c|
      if c[:expires].nil?
        c[:expires] = (DateTime.now + 30).to_s #arbitrary date in the future
      else
        c[:expires] = c[:expires].to_s
      end
      @client.cookie_jar << Mechanize::Cookie.new(c)
    end

    File.write COOKIE_FILE, (JSON cookies)
  end


  def read_cookie

    return true if @cookies

    return false until File.exists? COOKIE_FILE

    content = File.read(COOKIE_FILE)
    @cookies = JSON.parse content
    @cookies.each do |c|
      @client.cookie_jar << Mechanize::Cookie.new(c)
    end
  end


end
