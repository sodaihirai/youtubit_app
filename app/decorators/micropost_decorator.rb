# Micropostモデルのデコレータークラス
class MicropostDecorator < Draper::Decorator
  delegate_all

  def like?
    !object.likes.find_by(user_id: h.current_user.id).nil?
  end
end
