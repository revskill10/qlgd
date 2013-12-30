#encoding: utf-8
namespace :survey do    
    task generate: :environment do
    	s = Survey.where(name: "Đánh giá dự giờ").first_or_create
    	s.questions.create(name: "Khuyến khích sinh viên tích cực và chủ động học tập")
    	s.questions.create(name: "Kết nối được kiến thức hiện có và trải nghiệm của sinh viên với bài học")
    	s.questions.create(name: "Coi trọng sự đa dạng, đa chiều")
    	s.questions.create(name: "Khuyến khích sinh viên phát triển, mở rộng nhận thức và hiểu biết")
    	s.questions.create(name: "Hoạt động dạy/học có sự kết nối rõ ràng với chuẩn đầu ra")
    	s.questions.create(name: "Sự gắn kết với các kết quả nghiên cứu và thực tế nghề nghiệp")
    	s.questions.create(name: "Sử dụng hiệu quả các nguồn lực và kỹ thuật giảng dạy")
    	s.questions.create(name: "Cấu trúc các hoạt động dạy/học hợp lý và logic")
    	s.questions.each do |q|
    		q.data ||= {}
    		q.data["1"] = "Không có minh chứng"
    		q.data["2"] = "Một vài minh chứng"
    		q.data["3"] = "Có nhiều minh chứng"
    		q.data["4"] = "Có rất nhiều minh chứng"
    		q.data["5"] = "Không rõ tính hiệu quả"
    		q.data["6"] = "Hiệu quả thấp"
    		q.data["7"] = "Hiệu quả trung bình"
    		q.data["8"] = "Hiệu quả cao"
    		q.save!
    	end
   	end
end