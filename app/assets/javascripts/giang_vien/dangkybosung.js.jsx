/** @jsx React.DOM */



var MDATA = [
	{id: 1, thoi_gian: '12/08/2013', tiet_bat_dau: 1, so_tiet: 3, phong: 'A101', thuc_hanh: false, status: 'waiting'},
	{id: 2, thoi_gian: '19/08/2013', tiet_bat_dau: 2, so_tiet: 3,phong: 'A103', thuc_hanh: false, status: 'accepted'},
	{id: 3, thoi_gian: '20/08/2013', tiet_bat_dau: 2, so_tiet: 3,phong: 'A203', thuc_hanh: false, status: 'dropped'}
];


var Bosung = React.createClass({
	getInitialState: function(){
		return {data: [], add: 0};
	},
	updateLich: function(){
 		if (ENV.lich_id != null) {
        	React.unmountAndReleaseReactRootNode(document.getElementById('main'));
        	React.renderComponent(  
			  <Lich lich={ENV.lich_id} lop={ENV.lop_id} />,
			  document.getElementById('main')
			);  
        }	
 	},
	loadData: function(){
		$.ajax({
          url: "/teacher/lop/"+this.props.lop +"/lich_trinh_giang_days/bosung" ,
          success: function(data) {                      
            this.setState({data: data, add: 0});
          }.bind(this)
        });  		
	},
	componentWillMount: function(){
		this.loadData();
	},
	onAdd: function(){
		this.setState({add: 1});
	},
	onSubmitAdd: function(){
		if (this.state.add == 1){
			var tiet_bat_dau = this.refs.tiet_bat_dau.getDOMNode().value;
			var thoi_gian = this.refs.thoi_gian.getDOMNode().value;
			var phong = this.refs.phong.getDOMNode().value;
			var so_tiet = this.refs.so_tiet.getDOMNode().value;
			var ltype = this.refs.ltype.getDOMNode().value;
			var data = {thoi_gian: thoi_gian, tiet_bat_dau: tiet_bat_dau, phong: phong, so_tiet: so_tiet, ltype: ltype};
			$.ajax({
            url: "/teacher/lop/" + this.props.lop + "/lich_trinh_giang_days/create_bosung",
	            type: 'POST',
	            data: data,
	            success: function(data) {             
	                this.setState({data: data, add: 0}); 
	                React.unmountAndReleaseReactRootNode(document.getElementById('calendar'));
            		React.renderComponent(<Calendar  lop={this.props.lop} />
                , document.getElementById('calendar'));            		
	            }.bind(this)           
	        });			
		}
		
		return false;
	},
	onCancelAdd: function(){
		this.setState({add: 0});
	},
	onUpdate: function(data){		
		data._method = "put";
		$.ajax({
            url: "/teacher/lop/" + this.props.lop + "/lich_trinh_giang_days/update_bosung",
	            type: 'POST',
	            data: data,
	            success: function(data) {             
	                this.setState({data: data, add: 0});
	                React.unmountAndReleaseReactRootNode(document.getElementById('calendar'));
            		React.renderComponent(<Calendar  lop={this.props.lop} />
                , document.getElementById('calendar')); 
            		this.updateLich();
	            }.bind(this)           
	        });	
	},
	onRemove: function(data){		
		data._method = "delete";
		$.ajax({
            url: "/teacher/lop/" + this.props.lop + "/lich_trinh_giang_days/remove_bosung",
	            type: 'POST',
	            data: data,
	            success: function(data) {             
	                this.setState({data: data, add: 0}); 
	                React.unmountAndReleaseReactRootNode(document.getElementById('calendar'));
            		React.renderComponent(<Calendar  lop={this.props.lop} />
                , document.getElementById('calendar'));
            		this.updateLich();
	            }.bind(this)           
	        });	
	},
	onRestore: function(data){		
		$.ajax({
            url: "/teacher/lop/" + this.props.lop + "/lich_trinh_giang_days/restore_bosung",
	            type: 'POST',
	            data: data,
	            success: function(data) {             
	                this.setState({data: data, add: 0}); 
	                React.unmountAndReleaseReactRootNode(document.getElementById('calendar'));
            		React.renderComponent(<Calendar lop={this.props.lop} />, document.getElementById('calendar'));	
            		this.updateLich();
	            }.bind(this)           
	        });	
	},
	componentDidUpdate: function(){
		if (this.state.add == 1) {
			$('.input-append.date').datepicker({
				format: "dd/mm/yyyy",
				startDate: "13/1/2014",
				todayBtn: "linked",
	    		language: "vi",
	    		autoClose: true,
	    		todayHighlight: true
	    	});
		}
	},
	render: function(){
		var self = this;
		var x = this.state.data.map(function(d){
			return <Row2 key={'row2'+d.id} onUpdate={self.onUpdate} onRemove={self.onRemove} onRestore={self.onRestore} data={d} />
		});		
		if (this.state.add === 0) {
			return (
				<div>
					<br />
					<button class="btn btn-sm btn-success curl-top-left" onClick={this.onAdd} >Đăng ký bổ sung</button>
					<div class="table-responsive">
						<table class="table table-bordered">
							<thead>
								<th>Stt</th>
								<th>Thời gian</th>
								<th>Tiết bắt đầu</th>
								<th>Số tiết</th>
								<th>Phòng</th>
								<th>Loại</th>
								<th>Trạng thái</th>
							</thead>
							<tbody>
								{x}
							</tbody>
						</table>
					</div>
				</div>
			);
		} else if (this.state.add === 1) {
			return (
				<div>
					<br />
					<div class="table-responsive">
						<table class="table table-bordered">
							<thead>
								<th>Thời gian</th>								
								<th>Tiết bắt đầu</th>								
								<th>Số tiết dạy</th>
								<th>Phòng</th>
								<th>Loại</th>
								<th>Thực hiện</th>
							</thead>
							<tbody>
								<td>
								    <div class="input-append date">
								    	<input ref="thoi_gian" type="text" class="span2" /><span class="add-on"><i class="icon-th"></i></span>
								    </div>
								</td>
								<td>
									<select ref="tiet_bat_dau" class="form-control input-sm">
										<option value="1">1 (6h30)</option>
										<option value="2">2 (7h20)</option>
										<option value="3">3 (8h10)</option>
										<option value="4">4 (9h05)</option>
										<option value="5">5 (9h55)</option>
										<option value="6">6 (10h45)</option>
										<option value="7">7 (12h30)</option>
										<option value="8">8 (13h20)</option>
										<option value="9">9 (14h10)</option>
										<option value="10">10 (15h05)</option>
										<option value="11">11 (15h55)</option>
										<option value="12">12 (16h45)</option>
										<option value="13">13 (18h00)</option>
										<option value="14">14 (18h50)</option>
										<option value="15">15 (19h40)</option>
										<option value="16">16 (20h30)</option>
									</select>
								</td>
								<td>
									<input type="text" ref="so_tiet" placeholder="Số tiết dạy" class="form-control input-sm" />
								</td>
								<td>
									<input type="text" placeholder="Phòng" ref="phong" class="form-control input-sm" />
								</td>
								<td>
									<select ref="ltype" class="form-control input-sm">
										<option value="lythuyet">Lý thuyết</option>
										<option value="thuchanh">Thực hành</option>
										<option value="tuhoc">Tự học</option>
										<option value="baitap">Bài tập</option>
									</select>
								</td>								
								<td>
									<button class="btn btn-sm btn-success curl-top-left" onClick={this.onCancelAdd} >Hủy</button>
									<button class="btn btn-sm btn-success curl-top-left" onClick={this.onSubmitAdd} >Cập nhật</button>
								</td>
							</tbody>
						</table>
					</div>
					<hr />
					
					<div class="table-responsive">
						<table class="table table-bordered">
							<thead>
								<th>Stt</th>
								<th>Thời gian</th>
								<th>Tiết bắt đầu</th>
								<th>Số tiết</th>
								<th>Phòng</th>
								<th>Loại</th>
								<th>Trạng thái</th>
							</thead>
							<tbody>
								{x}
							</tbody>
						</table>
					</div>
				</div>
			);
		}
		
	}
});

var Row2 = React.createClass({
	getInitialState: function(){
		return {edit: 0}
	},
	onClickEdit: function(){
		this.setState({edit: 1});
	},
	handleCancelEdit: function(){
		this.setState({edit: 0});
	},
	handleUpdate: function(){
		if (this.state.edit == 1){
			var tiet_bat_dau = this.refs.tiet_bat_dau.getDOMNode().value;
			var thoi_gian = this.refs.thoi_gian.getDOMNode().value;
			var phong = this.refs.phong.getDOMNode().value;
			var so_tiet = this.refs.so_tiet.getDOMNode().value;
			var ltype = this.refs.ltype.getDOMNode().value;
			var data = {
				id: this.props.data.id,
				tiet_bat_dau: tiet_bat_dau,
				thoi_gian: thoi_gian,
				phong: phong,
				so_tiet: so_tiet,
				ltype: ltype
			};
			this.setState({edit: 0});
			this.props.onUpdate(data);		
		}	
	},
	componentDidUpdate: function(){
		if (this.state.edit == 1){
			this.refs.thoi_gian.getDOMNode().value = this.props.data.thoi_gian;
			this.refs.tiet_bat_dau.getDOMNode().value = this.props.data.tiet_bat_dau;
			this.refs.so_tiet.getDOMNode().value = this.props.data.so_tiet;
			this.refs.phong.getDOMNode().value = this.props.data.phong;	
			this.refs.ltype.getDOMNode().value = this.props.data.ltype;
			$('.input-append.date').datepicker({
				format: "dd/mm/yyyy",
				startDate: "13/1/2014",
				todayBtn: "linked",
	    		language: "vi",
	    		autoClose: true,
	    		todayHighlight: true
	    	});
		}		
	},
	onRemove: function(){
		if (confirm('Đồng ý')) {
			this.props.onRemove(this.props.data);
		}
	},
	onRestore: function(){
		if (confirm('Đồng ý')) {
			this.props.onRestore(this.props.data);
		}
	},
	render: function(){	
		if (this.state.edit === 0) {
			return (
				<tr><td>{this.props.data.id}</td>
				<td>{this.props.data.thoi_gian}</td>
				<td>{this.props.data.tiet_bat_dau}</td>
				<td>{this.props.data.so_tiet}</td>
				<td>{this.props.data.phong}</td>
				<td>{this.props.data.type_status}</td>
				<td>{this.props.data.alias_status}</td>
				<td><button class="btn btn-sm btn-success curl-top-left" onClick={this.onClickEdit} style={{display: this.props.data.can_edit === false ? 'none' : ''}} >Sửa</button>
				<button class="btn btn-sm btn-danger curl-top-left" onClick={this.onRemove} style={{display: this.props.data.can_remove === false ? 'none' : ''}} >Xóa</button>
				<button class="btn btn-sm btn-info curl-top-left" onClick={this.onRestore} style={{display: this.props.data.can_restore === false ? 'none' : ''}} >Phục hồi</button></td>
				</tr>
			);
		} else {
			return (				
				<tr>
					<td>{this.props.data.id}</td>
					<td>
					    <div class="input-append date">
					    	<input ref="thoi_gian" type="text" class="span2" /><span class="add-on"><i class="icon-th"></i></span>
					    </div>
					</td>
					<td>
						<select ref="tiet_bat_dau" class="form-control input-sm">
							<option value="1">1 (6h30)</option>
							<option value="2">2 (7h20)</option>
							<option value="3">3 (8h10)</option>
							<option value="4">4 (9h05)</option>
							<option value="5">5 (9h55)</option>
							<option value="6">6 (10h45)</option>
							<option value="7">7 (12h30)</option>
							<option value="8">8 (13h20)</option>
							<option value="9">9 (14h10)</option>
							<option value="10">10 (15h05)</option>
							<option value="11">11 (15h55)</option>
							<option value="12">12 (16h45)</option>
							<option value="13">13 (18h00)</option>
							<option value="14">14 (18h50)</option>
							<option value="15">15 (19h40)</option>
							<option value="16">16 (20h30)</option>
						</select>
					</td>
					<td>
						<input type="text" ref="so_tiet" class="form-control input-sm" />
					</td>
					<td>
						<input type="text" ref="phong" class="form-control input-sm" />
					</td>
					<td>
						<select ref="ltype" class="form-control input-sm">
							<option value="lythuyet">Lý thuyết</option>
							<option value="thuchanh">Thực hành</option>
							<option value="tuhoc">Tự học</option>
							<option value="baitap">Bài tập</option>
						</select>
					</td>
					<td>
						{this.props.data.alias_status}
					</td>
					<td>
						<input onClick={this.handleCancelEdit} class="btn btn-sm" type="submit" value="Cancel" />
						<input onClick={this.handleUpdate} class="btn btn-sm btn-primary" type="submit" value="Update" />
					</td>
				
				</tr>
			);
		}
		
	}
});