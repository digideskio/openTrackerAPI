module Api
  module V1
    class PositionsController < ApplicationController
      skip_authorization_check
      before_filter :load_parents
      before_filter :load_and_auth_sess

      def create
        position = Position.new position_params
        position.lap = @lap

        if position.save
          render json: position, status: :created
        else
          render json: position
        end
      end

      private

      def position_params
        params.require(:position).permit(:x, :y, :z, :speed, :rpm, :gear,
                                         :on_gas, :on_brake, :on_clutch, :steer_rot)
      end

      def load_parents
        @lap = Lap.find_by_id(params[:lap_id])
        @session = @lap.session
      end

      def load_and_auth_sess
        ensure_session_auth @session
      end
    end
  end
end