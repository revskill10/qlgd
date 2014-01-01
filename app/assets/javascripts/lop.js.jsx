/** @jsx React.DOM */
//= require assignments
//= require grade
//= require dangkybosung
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
				<table class="table table-bordered table-condensed">
				<thead>
					<td>Stt</td>
					<td>Mã sinh viên</td>
					<td>Họ và tên</td>
					<td>Tình hình</td>					
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
	            <td>Mã lớp</td>
	            <td>Tên môn học</td>
	            <td>Sĩ số</td>
	            <td>Số tiết lý thuyết</td>
	            <td>Số tiết thực hành</td>
	            <td>Ngôn ngữ</td>	            
	            <td>Trạng thái</td>      
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
				<Enrollments enrollments={this.props.data.enrollments} />	
			</div>
		);
	}
});

var ThongSo = React.createClass({
	getInitialState: function(){
		return {data: {}}
	},
	handleSubmit: function(){
		var lt = this.refs.lt.getDOMNode().value.trim();
    	var th = this.refs.th.getDOMNode().value.trim();
    	var lang = this.refs.lang.getDOMNode().value;
    	var decuong = this.refs.dcdk.getDOMNode().value.trim();
    	if  (!lt || !th) {
    	  alert("Bạn cần nhập số tiết lý thuyết và số tiết thực hành");
	      return false;
	    }
    	var data = {
    		id: this.state.data.id,
    		lt: lt,
    		th: th,
    		lang: lang,
    		decuong: decuong
    	}
    	$.ajax({
	      url: "/lop/settinglop",
	      type: 'POST',
	      data: data,
	      success: function(data2) {             
	        this.setState({data : data2.lop});	 
	        React.unmountAndReleaseReactRootNode('main');
			React.renderComponent(
				<Lop data={data2} />
				, document.getElementById('main')
			);       
	      }.bind(this)
	    });
	    return false;
	},
	componentWillMount: function(){
		$.ajax({
			url: "/lop/"+this.props.lop+ "/show.json" ,
			success: function(data) {                      			
				this.setState({data: data.lop});					
				React.renderComponent(
					<Lop data={data} />
					, document.getElementById('main')
				);
			}.bind(this)
		});
	},
	componentDidUpdate: function(){		
		$('#lang').val(this.state.data.language);
		$('#lt').val(this.state.data.so_tiet_ly_thuyet);
		$('#th').val(this.state.data.so_tiet_thuc_hanh);
		$('#dcdk').val(this.state.data.de_cuong_du_kien);
	},
	render: function(){
		return (
			<div>
			<br />
			<form onSubmit={this.handleSubmit}>
				<input type="submit" value="Cập nhật" class="btn btn-primary"/>
				<table class="table table-bordered table-condensed">
		          <thead>
		            <td>Thông số</td>		            
		            <td>Giá trị</td>
		          </thead>
		          <tbody>
		          	<tr><td>Mã lớp:</td><td>{this.state.data.ma_lop}</td></tr>
		            <tr><td>Tên môn học</td><td>{this.state.data.ten_mon_hoc}</td></tr>
		            <tr><td>Sĩ số</td><td>{this.state.data.si_so}</td></tr>
		            <tr><td>Số tiết lý thuyết</td><td><input id="lt" type="text" ref="lt" /></td></tr>
		            <tr><td>Số tiết thực hành</td><td><input id="th" type="text" ref="th" /></td></tr>
		            <tr><td>Ngôn ngữ</td><td>
		            	  <select id="lang" ref="lang">
						    <option value="vietnamse">Tiếng Việt</option>
						    <option value="chinense">Tiếng Trung Quốc</option>
						    <option value="japanese">Tiếng Nhật</option>
						  </select>

		            </td></tr>
		            <tr><td>Đề cương dự kiến</td><td><textarea id="dcdk" ref="dcdk" style={{minHeight: 300}} /></td></tr>		            
		          </tbody>           
		        </table> 
		        
		    </form>
	        </div>
		);
	}
});
var data = {};



React.renderComponent(
	<ThongSo lop={ENV.lop_id} />
	, document.getElementById('thongso')
);
			

React.renderComponent(<Assignments giang_vien={ENV.giang_vien_id} lop={ENV.lop_id} />
				, document.getElementById('assignment'));
React.renderComponent(<Bosung />, document.getElementById('bosung'));
