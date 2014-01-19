/** @jsx React.DOM */
//= require ./thongso
//= require ./assignments
//= require ./grade2
//= require ./dangkybosung
//= require ./calendar
var Enrollment = React.createClass({

	render: function(){

		return(
			<tr>
				<td>{this.props.stt}</td>
				<td>{this.props.enrollment.code}</td>
				<td>{this.props.enrollment.name}</td>
				<td>{this.props.enrollment.tong_vang}</td>
			</tr>
		);
	}
});

var Enrollments = React.createClass({	
    
	render: function(){
		var enrollments = this.props.enrollments.map(function (enrollment, i) {
	      return <Enrollment key={enrollment.id} stt={i} enrollment={enrollment} />;
	    }); 
		return (
			<div>
				<h5>Danh sách sinh viên</h5>
				<table class="table table-bordered table-condensed table-striped">
				<thead><tr class="success">
					<td>Stt</td>
					<td>Mã sinh viên</td>
					<td>Họ và tên</td>
					<td>Tình hình</td>		</tr>			
				</thead>
				<tbody>
					{enrollments}
				</tbody>           
        </table>
			</div>
		);
	}
});
var Setting = React.createClass({
	render: function(){
		return (
			<div>          
	        <h6>Thông tin lớp học:</h6>        	        
	        <table class="table table-bordered table-condensed">
	          <thead>
	          <tr class="success">
	            <td>Mã lớp</td>
	            <td>Tên môn học</td>
	            <td>Sĩ số</td>
	            <td>Số tiết lý thuyết</td>
	            <td>Số tiết thực hành</td>
	            <td>Ngôn ngữ</td>	            
	            <td>Trạng thái</td>   
	            </tr>   
	          </thead>
	          <tbody>
	              <td>{this.props.lop.ma_lop}</td>
	              <td>{this.props.lop.ten_mon_hoc}</td>
	              <td>{this.props.lop.si_so}</td>
	              <td>{this.props.lop.so_tiet_ly_thuyet}</td>
	              <td>{this.props.lop.so_tiet_thuc_hanh}</td>
	              <td>{this.props.lop.language}</td>	              
	              <td>{this.props.lop.updated === true ? 'Đã cấu hình' : 'Chưa cấu hình'}</td>              
	          </tbody>           
	        </table>        
	      </div>
		);
	}
});
var Lop = React.createClass({   	
	render: function(){
		return (
			<div>
				<Setting lop={this.props.data.lop} />
				<div id="grades2"></div>	
			</div>
		);
	}
});


var data = {};



React.renderComponent(
	<ThongSo lop={ENV.lop_id} />
	, document.getElementById('thongso')
);
			

React.renderComponent(<Assignments lop={ENV.lop_id} />
				, document.getElementById('assignment'));
React.renderComponent(<Grade2 lop={ENV.lop_id} />,
                                document.getElementById("grades"));
React.renderComponent(<Bosung lop={ENV.lop_id} />, document.getElementById('bosung'));
React.renderComponent(<Calendar lop={ENV.lop_id} />, document.getElementById('calendar'));

