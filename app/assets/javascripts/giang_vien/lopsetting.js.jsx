 /** @jsx React.DOM */


var LopSetting = React.createClass({
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
	      url: "/teacher/lop/settinglop",
	      type: 'POST',
	      data: data,
	      success: function(data2) {             
	        this.setState({data : data2.lop, edit: 0});	 
	        if (ENV.lich_id != null) {
	        	React.unmountAndReleaseReactRootNode(document.getElementById('main'));
	        	React.renderComponent(  
				  <Lich lich={ENV.lich_id} lop={ENV.lop_id} />,
				  document.getElementById('main')
				);  
	        }	           
	      }.bind(this)
	    });
	    return false;
	},
	componentWillMount: function(){
		$.ajax({
			url: "/teacher/lop/"+this.props.lop+ "/show.json" ,
			success: function(data) {                      			
				this.setState({data: data.lop});									
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

		if (this.state.edit === 1){
			return (
			<div>
			<br />
			<form onSubmit={this.handleSubmit}>
				<input type="submit" value="Cập nhật" class="btn btn-primary"/>
				<button onClick={this.onCancelEdit} class="btn btn-sm btn-warning">Hủy</button>
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
		} else {
			return (
				<div>
					<br/>
					<button onClick={this.onEdit} class="btn btn-sm btn-success">Sửa</button>					
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
			            <tr><td>Ngôn ngữ</td><td>
			            	  {this.state.data.language}
			            </td></tr>
			            <tr>
				            <td>Đề cương dự kiến</td>
				            <td>
				            	<p>
				            	<span dangerouslySetInnerHTML={{__html: this.state.data.de_cuong_du_kien_html }} />				            		
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