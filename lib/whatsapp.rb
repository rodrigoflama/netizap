require 'net/http'
require 'json'
require 'httpnetizap'

class WhatsApp
  def initialize()
    @httpNetizap = HttpNetizap.new
  end

  def appname=(value)
    @httpNetizap.appname = value
  end

  def token=(value)
    @httpNetizap.token = value
  end

  def url=(value)
    @httpNetizap.url = value
  end

  def line=(value)
    @httpNetizap.line = value
  end

  def questionSend(id, destiny, text, question)
    result = @httpNetizap.questionSend(destiny, text, question)
    protocol = getProtocol(result.body)
    response = @httpNetizap.questionSearch(protocol)

    Message.update(id, result: result.body, protocol: protocol, response: response)
  end

  def messageSend(id, destiny, text)
    result = @httpNetizap.messageSend(destiny, text)
    protocol = getProtocol(result.body)
    response = @httpNetizap.messageSearch(protocol)

    Message.update(id, result: result.body, protocol: protocol, response: response)
  end

  def messageSearch(id, protocol)
    response = @httpNetizap.messageSearch(protocol)

    Message.update(id, response: response)
  end

  def questionSearch(id, protocol)
    response = @httpNetizap.questionSearch(protocol)

    Message.update(id, response: response)
  end

  def getProtocol(body)
    protocol = ''

    if (body.present?) && (body.downcase.include? 'result')
      if (! body.downcase.include? '[')
        body = "["+body+"]"
      end

      arrayResult = JSON.parse(body)
      arrayResult.each do |object|
        protocol = object["result"]
      end
    end

    protocol
  end
end
