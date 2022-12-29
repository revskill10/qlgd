 /** @jsx React.DOM */


var ThongSo = React.createClass({
	getInitialState: function(){
		return {data: {}, edit: 0}
	},
	onEdit: function(){
		this.setState({edit: 1});
	},
	onCancelEdit: function(){
		this.setState({edit: 0});
	},
	handleSubmit: function(){
		var lt = this.refs.lt.getDOMNode().value.trim();
    	var th = this.refs.th.getDOMNode().value.trim();
    	var tuhoc = this.refs.tuhoc.getDOMNode().value.trim();
    	var bt = this.refs.bt.getDOMNode().value.trim();
    	var lang = this.refs.lang.getDOMNode().value;
    	var lichtrinh = $('#ltdk').code();
    	var decuong = $('#dcct').code();
    	if  (!lt || !th) {
    	  alert("Bạn cần nhập số tiết lý thuyết và số tiết thực hành");
	      return false;
	    }
    	var data = {
    		id: this.state.data.id,
    		lt: lt,
    		th: th,
    		tuhoc: tuhoc,
    		bt: bt,
    		lang: lang,
    		lichtrinh: lichtrinh,
    		decuong: decuong
    	}
    	$.ajax({
	      url: "/teacher/lop/settinglop",
	      type: 'POST',
	      data: data,
	      success: function(data2) {             
	        this.setState({data : data2.lop, edit: 0});	 
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
			url: "/teacher/lop/"+this.props.lop+ "/show.json" ,
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
		if (this.state.edit === 1){
			$('#dcct').summernote({height: 150});
			$('#ltdk').summernote({height: 150});
			$('#ltdk').code(this.state.data.lich_trinh_du_kien);		
			$('#dcct').code(this.state.data.de_cuong_chi_tiet);
		}		
		$('#lang').val(this.state.data.language);
		$('#lt').val(this.state.data.so_tiet_ly_thuyet);
		$('#th').val(this.state.data.so_tiet_thuc_hanh);
		$('#tuhoc').val(this.state.data.so_tiet_tu_hoc);
		$('#bt').val(this.state.data.so_tiet_bai_tap);		
	},
	render: function(){

		if (this.state.edit === 1){
			return (
			<div>
			<br />
			<form onSubmit={this.handleSubmit}>
				<input type="submit" value="Cập nhật" class="btn btn-primary"/>
				<button onClick={this.onCancelEdit} class="btn btn-sm btn-warning curl-top-left">Hủy</button>
				<table class="table table-bordered table-condensed table-striped">
		          <thead><tr class="success">
		            <td>Thông số</td>		            
		            <td>Giá trị</td></tr>
		          </thead>
		          <tbody>
		          	<tr><td>Mã lớp:</td><td>{this.state.data.ma_lop}</td></tr>
		            <tr><td>Tên môn học</td><td>{this.state.data.ten_mon_hoc}</td></tr>
		            <tr><td>Sĩ số</td><td>{this.state.data.si_so}</td></tr>
		            <tr><td>Số tiết lý thuyết</td><td><input id="lt" type="text" ref="lt" /></td></tr>
		            <tr><td>Số tiết thực hành</td><td><input id="th" type="text" ref="th" /></td></tr>
		            <tr><td>Số tiết tự học</td><td><input id="tuhoc" type="text" ref="tuhoc" /></td></tr>
		            <tr><td>Số tiết bài tập</td><td><input id="bt" type="text" ref="bt" /></td></tr>
		            <tr><td>Ngôn ngữ</td><td>
		            	  <select id="lang" ref="lang">
						    <option value="vietnamse">Tiếng Việt</option>
						    <option value="english">Tiếng Anh</option>
						    <option value="chinese">Tiếng Trung Quốc</option>
						    <option value="japanese">Tiếng Nhật</option>
						  </select>

		            </td></tr>
		            <tr><td>Lịch trình dự kiến</td><td><div id="ltdk" ref="ltdk" style={{"width":"80%"}} /></td></tr>		            
		            <tr><td>Đề cương chi tiết</td><td><div id="dcct" ref="dcct" style={{"width":"80%"}} /></td></tr>		            
		          </tbody>           
		        </table> 
		        
		    </form>
	        </div>
		);
		} else {
			return (
				<div>
					<br/>
					<button onClick={this.onEdit} class="btn btn-sm btn-success curl-top-left">Sửa</button>					
					<table class="table table-bordered table-condensed">
			          <thead>
			            <td>Thông số</td>		            
			            <td>Giá trị</td>
			          </thead>
			          <tbody>
			          	<tr><td>Mã lớp:</td><td>{this.state.data.ma_lop}</td></tr>
			            <tr><td>Tên môn học</td><td>{this.state.data.ten_mon_hoc}</td></tr>
			            <tr><td>Sĩ số</td><td>{this.state.data.si_so}</td></tr>
			            <tr><td>Số tiết lý thuyết</td><td>{this.state.data.so_tiet_ly_thuyet}</td></tr>
			            <tr><td>Số tiết thực hành</td><td>{this.state.data.so_tiet_thuc_hanh}</td></tr>
			            <tr><td>Số tiết tự học</td><td>{this.state.data.so_tiet_tu_hoc}</td></tr>
			            <tr><td>Số tiết bài tập</td><td>{this.state.data.so_tiet_bai_tap}</td></tr>
			            <tr><td>Ngôn ngữ</td><td>
			            	  {this.state.data.language}
			            </td></tr>
			            <tr>
				            <td>Lịch trình dự kiến</td>
				            <td>
				            	<p>
				            	<span dangerouslySetInnerHTML={{__html: this.state.data.lich_trinh_du_kien}} />				            		
				            	</p>
				            </td>
			            </tr>	
			            <tr>
				            <td>Đề cương chi tiết</td>
				            <td>
				            	<p>
				            	<span dangerouslySetInnerHTML={{__html: this.state.data.de_cuong_chi_tiet}} />				            		
				            	</p>
				            </td>
			            </tr>		            	            
			          </tbody>           
			        </table> 			        
				</div>
			);
		}
		
	}
});