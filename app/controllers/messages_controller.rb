class MessagesController < ApplicationController
  require 'whatsapp'

  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    whatsapp = WhatsApp.new
    whatsapp.line = @message.sender
    whatsapp.url = @message.url
    whatsapp.appname = @message.appname
    whatsapp.token = @message.token
    whatsapp.messageSearch(@message.id, @message.protocol)
    #whatsapp.questionSearch(@message.id, @message.protocol)
  end

  # GET /messages/new
  def new
    @message = Message.new
    @message.url = "http://api.meuaplicativo.vip:13006"
    @message.sender = "5527992052989"
    @message.token = "S29TLg1jU5X0J1riC9WJ"
    @message.appname = "NetiZap"
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        whatsapp = WhatsApp.new
        whatsapp.line = @message.sender
        whatsapp.url = @message.url
        whatsapp.appname = @message.appname
        whatsapp.token = @message.token
        whatsapp.messageSend(@message.id, @message.recipient, @message.text)
        #whatsapp.questionSend(@message.id, @message.recipient, @message.text, "['Sim';'Não']")

        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:text, :result, :protocol, :response, :recipient, :sender, :url, :token, :appname)
    end
end
