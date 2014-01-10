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
    if extra_attributes["status"] != 0 and extra_attributes["masinhvien"]
        code = extra_attributes["masinhvien"].upcase
        sv = SinhVien.where(:code => code).first
        if sv
          self.imageable = sv          
        end
        gv = GiangVien.where(:code => code).first
        if gv
          self.imageable = gv               
        end
    end    
  end
 
  def lop_chinhs
    if self.imageable.is_a?(GiangVien) or self.imageable.is_a?(SinhVien)
      return self.imageable.lop_mon_hocs.pending_or_started
    end
    return []
  end
  def lop_tro_giangs
    self.lop_mon_hocs.pending_or_started
  end
  def get_lops
    lop_chinhs + lop_tro_giangs
  end
  
  def lich_chinhs
    if self.imageable.is_a?(GiangVien) or self.imageable.is_a?(SinhVien)
      return self.imageable.lich_trinh_giang_days
    end
  end
  def lich_tro_giangs
    tmp2 = []
    tmp = self.assistants
    if tmp.count > 0    
      tmp.each do |as|
        tmp2 += as.lich_trinh_giang_days.uniq
      end
    end
    tmp2
  end
  def get_lichs
    lich_chinhs + lich_tro_giangs
  end

  def hovaten
    if imageable != nil
      return imageable.hovaten    
    else
      return ho_dem + " " + ten
    end
  end

  def giang_vien(lop)
    gv = self.imageable if self.lop_chinhs.include?(lop)   
    assistant = lop.assistants.where(:user_id => self.id).first
    gv2 = assistant.giang_vien if assistant
    gv || gv2
  end
end
