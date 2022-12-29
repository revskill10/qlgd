 /** @jsx React.DOM */

var TaoLop = React.createClass({
	getInitialState: function(){
		return {giang_viens: [], mon_hocs: []}
	},
	loadData: function(){
		$.ajax({
			url: '/daotao/giang_viens',
			success: function(data){
				this.setState({giang_viens: data.giang_viens, mon_hocs: data.mon_hocs});
				React.renderComponent(<LopMonHoc2 giang_viens={this.state.giang_viens} />, document.getElementById('lop3'));
			}.bind(this)
		})
	},
	componentWillMount: function(){
		this.loadData();
	},	
	onCreateMon: function(){
		var ma_mon_hoc = this.refs.ma_mon_hoc.getDOMNode().value;
		var ten_mon_hoc = this.refs.ten_mon_hoc.getDOMNode().value;
		var data = {
			ma_mon_hoc: ma_mon_hoc,
			ten_mon_hoc: ten_mon_hoc
		}
		$.ajax({
			url: '/daotao/mon_hocs/create',
			type: 'POST',
			data: data,
			success: function(data){
				this.setState({giang_viens: data.giang_viens, mon_hocs: data.mon_hocs});
			}.bind(this)
		})
	},
	onCreate: function(){
		//alert($("#gv").val()+$("#mm").val()+this.refs.ma_lop.getDOMNode().value);
		var giang_vien_id = $('#gv4').val();
		var ma_mon_hoc = $('#mm').val();
		var ma_lop = this.refs.ma_lop.getDOMNode().value;		
		var data = {
			giang_vien_id: giang_vien_id,
			mon_hoc: ma_mon_hoc,			
			ma_lop: ma_lop
		}
		$.ajax({
			url: '/daotao/lop_mon_hocs/create',
			type: 'POST',
			data: data,
			success: function(data){
				if (data.error != null) { alert(data.error);}				
				React.unmountAndReleaseReactRootNode(document.getElementById('lop3'));	
				React.renderComponent(<LopMonHoc2 giang_viens={this.state.giang_viens} />, document.getElementById('lop3'));
				React.unmountAndReleaseReactRootNode(document.getElementById('gheplop'));	
				React.renderComponent(<GhepLop />, document.getElementById('gheplop')); 
				React.unmountAndReleaseReactRootNode(document.getElementById('calendar2'));	
 				React.renderComponent(<DaotaoCalendar />, document.getElementById('calendar2'));
			}.bind(this)
		})
	},
	componentDidUpdate: function(){
		var self = this;
		$("#gv4").select2({
			data: self.state.giang_viens
		});
		$("#mm").select2({
			data: self.state.mon_hocs
		});		
	},
	render: function(){
		return (
			<div>
				<hr />
				<h4>Thêm môn học</h4>
				<table class="table table-bordered">
					<thead>
						<tr class="success">
							<td>Mã môn học</td>
							<td>Tên môn học</td>
							<td>Thao tác</td>
						</tr>
					</thead>
					<tbody>
						<tr class="danger">
							<td>
								<input type="text" ref="ma_mon_hoc" placeholder="Mã môn học" style={{width: "100%"}} /><br />
							</td>
							<td>
								<input type="text" ref="ten_mon_hoc" placeholder="Tên môn học" style={{width: "100%"}} /><br />
							</td>
							<td>
								<button class="btn btn-success" onClick={this.onCreateMon}>Thêm môn</button>
							</td>
						</tr>
					</tbody>
				</table>
				<hr />
				<h4>Tạo lớp</h4>
				<table class="table table-bordered">
					<thead>
						<tr class="success">
							<td>Mã lớp</td>
							<td>Môn học</td>
							<td>Giảng viên</td>
							<td>Thao tác</td>
						</tr>
					</thead>
					<tbody>
						<tr class="danger">
							<td><input type="text" ref="ma_lop" placeholder="Mã lớp" style={{width: "100%"}} /></td>
							<td><input type="hidden" id="mm" placeholder="Môn học" style={{width:"100%"}} /></td>
							<td><input type="hidden" id="gv4" placeholder="Giảng viên" style={{width:"100%"}} class="input-xlarge" /></td>
							<td><button class="btn btn-success" onClick={this.onCreate}>Tạo lớp</button></td>
						</tr>
					</tbody>
				</table>				
				<hr />
				<div id="lop3"></div>
			</div>
		);
	}
});
 var LopMonHoc2 = React.createClass({
 	getInitialState: function(){
 		return {data: [], t: []}
 	},
 	loadData: function(){
 		$.ajax({
 			url: '/daotao/lops',
 			success: function(data){ 				
 				this.setState({data: data.lops, t: data.t});
 			}.bind(this)
 		})
 	},
 	componentWillMount: function(){
 		this.loadData();
 	}, 	
 	componentDidMount: function(){
 		var self = this;
 		
 		$('#mytable').dataTable({
		  "sPaginationType": "bootstrap",
		  "bAutoWidth": false,
		  "bDestroy": true,		
		  "fnDrawCallback": function() {		  		
            	self.forceUpdate();        	
          }, 
		});				
 	},
 	componentDidUpdate: function(){
 		var self = this;
 		$('#mytable').dataTable({
		  "sPaginationType": "bootstrap",
		  "bAutoWidth": false,
		  "bDestroy": true,	
		});
		$("#timlop").select2({
			data: self.state.t
		});
 	},
 	handleStart: function(d){
 		$.ajax({
 			url: '/daotao/lop_mon_hocs/start',
 			type: 'POST',
 			data: d,
 			success: function(data){
 				this.setState({data: data.lops, t: data.t});
 			}.bind(this)
 		});
 	},
 	handleRemove: function(d){
 		$.ajax({
 			url: '/daotao/lop_mon_hocs/remove',
 			type: 'POST',
 			data: d,
 			success: function(data){
 				this.setState({data: data.lops, t: data.t});
 			}.bind(this)
 		});
 	},
 	handleRestore: function(d){
 		$.ajax({
 			url: '/daotao/lop_mon_hocs/restore',
 			type: 'POST',
 			data: d,
 			success: function(data){
 				this.setState({data: data.lops, t: data.t});
 			}.bind(this)
 		});
 	},
 	handleUpdate: function(d){
 		$.ajax({
 			url: '/daotao/lop_mon_hocs/update',
 			type: 'POST',
 			data: d,
 			success: function(data){
 				this.setState({data: data.lops, t: data.t});
 			}.bind(this)
 		});
 	},
 	onSearch: function(){ 		
 		var lop = $('#timlop').val();
 		React.unmountAndReleaseReactRootNode(document.getElementById('assistant'));		
		React.renderComponent(<Assistant giang_viens={this.props.giang_viens} lop={lop} />, document.getElementById('assistant'));	
 	},
 	render: function(){
 		var self = this;
 		var x = this.state.data.map(function(d, index){
 			return <LopRow onUpdate={self.handleUpdate} onStart={self.handleStart} onRemove={self.handleRemove} onRestore={self.handleRestore} stt={index+1} data={d} /> 			
 		});
		return (
			<div>
				<h4>Tìm lớp</h4>
				<input type="hidden" id="timlop" placeholder="Lớp môn học" style={{width:"500px"}} class="input-xlarge" />
				<button class="btn btn-success" onClick={this.onSearch}>Tìm lớp</button>
				<div id="assistant"></div>
				<hr />
				<h4>Danh sách các lớp trong kỳ</h4>
			<div class="table-responsive">				
				<table class="table table-bordered" id="mytable">
					<thead>
						<tr class="success">
							<td>Stt</td>
							<td>Mã lớp</td>
							<td>Tên môn học</td>
							<td>Trạng thái</td>
							<td>Thao tác</td>
						</tr>	
					</thead>
					<tbody>
						{x}
					</tbody>
				</table>
			</div>
			</div>
		) 		
 	}
 });

 var LopRow = React.createClass({
 	getInitialState: function(){
 		return {edit: 0}
 	},
 	onStart: function(){
 		this.props.onStart(this.props.data);
 	},
 	onRemove: function(){
 		this.props.onRemove(this.props.data);
 	},
 	onRestore: function(){
 		this.props.onRestore(this.props.data);
 	},
 	onEdit: function(){
 		this.setState({edit: 1});
 	},
 	onCancel: function(){
 		this.setState({edit: 0});
 	},
 	onUpdate: function(){  				 	
 		var ma_lop = this.refs.ma_lop.getDOMNode().value; 		
 		this.props.onUpdate({id: this.props.data.id, ma_lop: ma_lop});
 		this.setState({edit: 0});
 	},
 	componentDidUpdate: function(){
 		if (this.state.edit === 1){
 			this.refs.ma_lop.getDOMNode().value = this.props.data.ma_lop;
 		}
 	},
 	render: function(){
 		if (this.state.edit === 0){
 			return (<tr><td>{this.props.stt}</td><td>{this.props.data.ma_lop}</td><td>{this.props.data.ten_mon_hoc}</td><td>{this.props.data.state}</td>
	 			<td>
	 			<button class="btn btn-sm btn-warning" onClick={this.onEdit}>Sửa</button>
	 			<button class="btn btn-sm btn-success" onClick={this.onStart} style={{"display": this.props.data.can_start === true ? "" : "none"}} >Bắt đầu</button>
	 			<button class="btn btn-sm btn-danger" onClick={this.onRemove} style={{"display": this.props.data.can_remove === true ? "" : "none"}}>Hủy</button>
	 			<button class="btn btn-sm btn-default" onClick={this.onRestore} style={{"display": this.props.data.can_restore === true ? "" : "none"}}>Phục hồi</button>
	 			</td></tr>
	 			);
 		} else {
 			return (<tr><td>{this.props.stt}</td>
 				<td><input type="text" ref="ma_lop" /></td>
 				<td>{this.props.data.ten_mon_hoc}</td>
 				<td>{this.props.data.state}</td>
	 			<td>
	 			<button class="btn btn-sm btn-default" onClick={this.onCancel}>Hủy</button>
	 			<button class="btn btn-sm btn-warning" onClick={this.onUpdate}>Cập nhật</button>
	 			<button class="btn btn-sm btn-success" onClick={this.onStart} style={{"display": this.props.data.can_start === true ? "" : "none"}} >Bắt đầu</button>
	 			<button class="btn btn-sm btn-danger" onClick={this.onRemove} style={{"display": this.props.data.can_remove === true ? "" : "none"}}>Hủy</button>
	 			<button class="btn btn-sm btn-default" onClick={this.onRestore} style={{"display": this.props.data.can_restore === true ? "" : "none"}}>Phục hồi</button>
	 			</td></tr>
	 			);
 		}
 		
 	}
 });

 var Assistant = React.createClass({
 	getInitialState: function(){
 		return {data: [], users: []}
 	},
 	loadData: function(){
 		$.ajax({
 			url: '/daotao/lop_mon_hocs/' + this.props.lop + '/assistants',
 			success: function(data){
 				this.setState({data: data});
 			}.bind(this)
 		});
 		$.ajax({
 			url: '/daotao/users',
 			success: function(data){
 				this.setState({users: data});
 			}.bind(this)
 		});
 	},
 	componentWillMount: function(){
 		this.loadData();
 	}, 	
 	componentDidUpdate: function(){
 		var self = this;
		$("#ast").select2({
			data: self.props.giang_viens
		});
 	},
 	handleDelete: function(d){
 		$.ajax({
 			url: '/daotao/lop_mon_hocs/' + this.props.lop + '/assistants/delete',
 			type: 'POST',
 			data: d,
 			success: function(data){
 				this.setState({data: data});
 			}.bind(this)
 		})
 	},
 	handleAdd: function(){
 		var giang_vien_id = $('#ast').val();
 		$.ajax({
 			url: '/daotao/lop_mon_hocs/' + this.props.lop + '/assistants/create',
 			type: 'POST',
 			data: {giang_vien_id: giang_vien_id},
 			success: function(data){
 				this.setState({data: data});
 			}.bind(this)		
 		});
 	},
 	handleUpdate: function(d){ 		 		
 		$.ajax({
 			url: '/daotao/lop_mon_hocs/' + this.props.lop + '/assistants/update',
 			type: 'POST',
 			data: d,
 			success: function(data){
 				this.setState({data: data});
 			}.bind(this)
 		})
 	},
 	render: function(){
 		var self = this;
 		var x = this.state.data.map(function(d, index){
 			return <AssistantRow onDelete={self.handleDelete} onUpdate={self.handleUpdate} users={self.state.users} stt={index+1} data={d} />
 		});
 		return (
 			<div>
 				<h4>Thêm giảng viên:</h4>
 				<input type="hidden" id="ast" placeholder="Chọn giảng viên" style={{width:"500px"}} class="input-xlarge" />
				<button class="btn btn-success" onClick={this.handleAdd}>Thêm giảng viên</button>
	 			<div class="table-responsive">
	 				<table class="table table-bordered">
	 					<thead>
	 						<tr class="success">
	 							<td>Stt</td>
	 							<td>Sử dụng tài khoản</td>
	 							<td>Giảng viên</td>
	 							<td>Mã giảng viên</td>
	 							<td>Trợ giảng?</td>
	 							<td>Thao tác</td>
	 						</tr>
	 					</thead>	
	 					<tbody>
	 						{x}
	 					</tbody>
	 				</table>
	 			</div>
 			</div>
 		);
 	}
 });
 var AssistantRow = React.createClass({
 	getInitialState: function(){
 		return {add: 0}
 	},
 	onEdit: function(){
 		this.setState({add: 1}); 		
 	},
 	onCancel: function(){
 		this.setState({add: 0});
 	},
 	onUpdate: function(){ 		
 		var username = $('#username').select2('data').text;
 		var id = this.props.data.id; 	
 		var trogiang = this.refs.trogiang.getDOMNode().checked;
 		this.setState({add: 0});	
 		this.props.onUpdate({username: username, id: id, trogiang: trogiang}); 		
 	},
 	onDelete: function(){
 		this.props.onDelete(this.props.data);
 	},
 	componentDidUpdate: function(){
 		if (this.state.add === 1){
 			var self = this;
			$("#username").select2({
				data: self.props.users
			});
			$('#username').select2('data',{id:this.props.data.username, text: this.props.data.username});
 		}
 	},
 	render: function(){
 		if (this.state.add === 0){
 			return (
	 			<tr class="danger">
	 				<td>{this.props.stt}</td>
	 				<td>{this.props.data.username}</td>
	 				<td>{this.props.data.hovaten}</td>
	 				<td>{this.props.data.code}</td>
	 				<td>{this.props.data.trogiang === true ? "Trợ giảng" : "Giảng viên chính"}</td>
	 				<td><button class="btn btn-sm btn-danger" onClick={this.onDelete}>Xóa</button>
	 				<button class="btn btn-sm btn-primary" onClick={this.onEdit}>Sửa</button>
	 				</td>	 				
	 			</tr>
	 		);
 		} else {
 			return (
 				<tr>
	 				<td>{this.props.stt}</td>
	 				<td>
	 					<input ref="username" type="hidden" id="username" style={{width:"100%"}} placeholder="email" />
	 				</td>
	 				<td>{this.props.data.hovaten}</td>
	 				<td>{this.props.data.code}</td>
	 				<td>
	 					<div class="checkbox">
					        <label>
					          <input ref="trogiang" value={this.props.trogiang} type="checkbox">Trợ giảng</input>
					        </label>
					    </div>
	 				</td>
	 				<td><button class="btn btn-sm btn-danger" onClick={this.onDelete}>Xóa</button>
	 					<button class="btn btn-sm btn-primary" onClick={this.onUpdate}>Cập nhật</button>
	 					<button class="btn btn-sm btn-warning" onClick={this.onCancel}>Hủy</button>
	 				</td>
	 			</tr>
 			);
 		}
 		
 	}
 });