class PromotionMove < Promotion
  def algebraic_notation
    "#{@point_end}=#{@promoted_to.algebraic_notation}"
  end

  def to_s
    "move #{@figure} from #{@point_start} to #{@point_end}, then promotion to #{@promoted_to}"
  end
end
