class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :cas_authenticatable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :code, :ho_dem, :ten, :imageable_id, :imageable_type
  # attr_accessible :title, :body
  belongs_to :imageable, :dependent => :destroy, :polymorphic => true
  has_many :du_gios, :dependent => :destroy

  has_many :user_groups, :dependent => :destroy
  has_many :groups, :through => :user_groups
  has_many :assistants, :dependent => :destroy
  
  has_many :lop_mon_hocs, :through => :assistants, :uniq => true

  def cas_extra_attributes=(extra_attributes)
    
    extra_attributes.each do |name, value|
      case name.to_sym
      when :masinhvien
        if value
          sv = SinhVien.where(code: value.upcase).first
          self.imageable = sv if sv
          gv = GiangVien.where(code: value.upcase).first
          if gv
            self.imageable = gv            
            gv.assistants.giang_vien_chinh.update_all(user_id: self.id)       
          end          
        end
      end
      self.email = self.username
    end
  end
 
  def get_lops    
    if self.imageable.is_a?(SinhVien)
      return self.imageable.enrollments.map {|en| en.lop_mon_hoc }.uniq
    else      
      self.assistants.map {|as| as.lop_mon_hoc if !as.lop_mon_hoc.removed? }.uniq
    end
  end  
  
  
  def get_lichs    
    #get_lops.inject([]) {|res, elem| res + elem.lich_trinh_giang_days}.sort_by {|l| [l.thoi_gian, l.phong]}
    if self.imageable.is_a?(SinhVien)
      get_lops.inject([]) {|res, elem| res + elem.lich_trinh_giang_days}.sort_by {|l| [l.thoi_gian, l.phong]}
    else
      ids = self.assistants.map(&:giang_vien_id)
      LichTrinhGiangDay.where(giang_vien_id: ids).includes(:lop_mon_hoc).includes(:vi_pham).sort_by {|l| [l.thoi_gian, l.phong]}
    end
  end
  

  def hovaten
    if imageable != nil
      return imageable.hovaten    
    else
      return ho_dem + " " + ten
    end
  end

  def giang_vien(lop)
    return nil if self.imageable.is_a?(SinhVien)
    gv = self.imageable if self.get_lops.include?(lop)   
    assistant = lop.assistants.where(:user_id => self.id).first
    gv2 = assistant.giang_vien if assistant
    gv || gv2
  end
end
