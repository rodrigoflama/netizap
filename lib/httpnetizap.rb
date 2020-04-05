require 'net/http'
require 'json'

class HttpNetizap
  attr_writer :appname
  attr_writer :token
  attr_writer :url
  attr_writer :line

  def messageSend(destiny, text)
    uri = URI(@url + '/services/message_send')

    Net::HTTP.start(uri.host, uri.port) do |http|
      params = {:line => @line,
                :destiny => destiny,
                :reference => '',
                :text => Base64.encode64(text)}

      httpRequest(http, uri, params)
    end
  end

  def questionSend(destiny, text, question)
    uri = URI(@url + '/services/question_send')

    Net::HTTP.start(uri.host, uri.port) do |http|
      params = {:line => @line,
                :destiny => destiny,
                :reference => '',
                :question => question,
                :text => Base64.encode64(text)}

      httpRequest(http, uri, params)
    end
  end

  def messageSearch(protocol)
    uri = URI(@url + '/services/message_send')

    Net::HTTP.start(uri.host, uri.port) do |http|
      response = getResponse(http, protocol, 'message_search')
    end
  end

  def questionSearch(protocol)
    uri = URI(@url + '/services/question_send')

    Net::HTTP.start(uri.host, uri.port) do |http|
      response = getResponse(http, protocol, 'question_search')
    end
  end

  private

  def httpRequest(http, uri, params)
    uri.query = URI.encode_www_form(params)

    request = Net::HTTP::Post.new(uri)
    request.basic_auth 'user', 'api'
    request.content_type = 'application/x-www-form-urlencoded'
    request.set_form_data(:App => @appname, :AccessKey => @token)
    http.request(request)
  end

  def getResponse(http, protocol, service_response)
    response = ''

    if (protocol.present?)
      params = {:line => @line,
                :App => @appname,
                :AccessKey => @token,
                :protocol => protocol}

      uri = URI(@url + '/services/' + service_response)
      uri.query = URI.encode_www_form(params)

      request = Net::HTTP::Get.new(uri)
      request.basic_auth 'user', 'api'
      request.content_type = 'application/x-www-form-urlencoded'

      response = http.request(request).body
    end

    response
  end
end
