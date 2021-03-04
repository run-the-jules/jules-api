class Api::V1::FriendshipsController < ApplicationController
  def index
    if params[:user_id]
      friend_ids = Friendship.friends(params[:user_id])
      friendships = FriendshipsFacade.compare(params[:user_id], friend_ids)
      render json: FriendUsageSerializer.new(friendships)
    else
      render json: { error: 'User id missing' }, status: 404
    end
  end

  def create
    friendship = Friendship.new(friendship_params)
    if friendship.save
      render json: FriendshipSerializer.new(friendship), status: :created
    else
      render json: { data: friendship.errors }, status: :conflict
    end
  end

  private

  def friendship_params
    params.require(:friendship).permit(:user_id, :following_id)
  end
end
