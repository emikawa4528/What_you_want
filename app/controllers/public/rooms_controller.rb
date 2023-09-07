class Public::RoomsController < ApplicationController
  before_action :authenticate_member!
  
  def create
    room = Room.create
    # 現在ログインしている会員とメッセージする相手のそれぞれの情報をroom_idで紐付けてEntryテーブルにcreateする
    current_entry = Entry.create(member_id: current_member.id, room_id: room.id)
    another_entry = Entry.create(member_id: params[:entry][:member_id], room_id: room.id)
    redirect_to room_path(room.id)
  end

  def index
    # ログインユーザーがやりとりしているroomのIDをすべて取得
    current_entries = current_member.entries
    # IDを配列化してmy_room_idとする
    my_room_id = []
    current_entries.each do |entry|
      my_room_id << entry.room.id
    end
    # Entryテーブルからmy_room_idでmember_idが自分のIDでないレコードを取り出す
    @another_entries = Entry.where(room_id: my_room_id).where.not(member_id: current_member.id)
  end

  def show
    @room = Room.find(params[:id])
    @messages = @room.messages.all
    @message = Message.new
    @entries = @room.entries
    @another_entry = @entries.where.not(member_id: current_member.id).first
  end


end
