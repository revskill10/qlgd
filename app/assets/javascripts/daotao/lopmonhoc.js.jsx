 /** @jsx React.DOM */

var TaoLop = React.createClass({
	getInitialState: function(){
		return {giang_viens: [], ma_mons: [], ten_mon_hocs: []}
	},
	loadData: function(){
		$.ajax({
			url: '/daotao/giang_viens',
			success: function(data){
				this.setState({giang_viens: data.giang_viens, ma_mons: data.ma_mons, ten_mon_hocs: data.ten_mon_hocs});
				React.renderComponent(<LopMonHoc2 giang_viens={this.state.giang_viens} />, document.getElementById('lop3'));
			}.bind(this)
		})
	},
	componentWillMount: function(){
		this.loadData();
	},	
	onCreate: function(){
		//alert($("#gv").val()+$("#mm").val()+this.refs.ma_lop.getDOMNode().value);
		var giang_vien_id = $('#gv').val();
		var ma_mon_hoc = $('#mm').val();
		var ma_lop = this.refs.ma_lop.getDOMNode().value;
		var ten_mon_hoc = $('#tenmonhoc').val();
		var data = {
			giang_vien_id: giang_vien_id,
			ma_mon_hoc: ma_mon_hoc,
			ten_mon_hoc: ten_mon_hoc,
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
				console.log(this.state.giang_viens);
			}.bind(this)
		})
	},
	componentDidUpdate: function(){
		var self = this;
		$("#gv").select2({
			data: self.state.giang_viens
		});
		$("#mm").select2({
			data: self.state.ma_mons
		});
		$("#tenmonhoc").select2({
			data: self.state.ten_mon_hocs
		});
	},
	render: function(){
		return (
			<div>
				<hr />
				<input type="text" ref="ma_lop" placeholder="Mã lớp" /><br />
				<input type="hidden" id="mm" placeholder="Mã môn học" style={{width:"500px"}} /><br />
				<input type="hidden" id="tenmonhoc" placeholder="Tên môn học" style={{width:"500px"}} /><br />
				<input type="hidden" id="gv" placeholder="Giảng viên" style={{width:"500px"}} class="input-xlarge" />
				<button class="btn btn-success" onClick={this.onCreate}>Tạo lớp</button>
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
 		return {data: []}
 	},
 	loadData: function(){
 		$.ajax({
 			url: '/daotao/lop_mon_hocs/' + this.props.lop + '/assistants',
 			success: function(data){
 				this.setState({data: data});
 			}.bind(this)
 		})
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
 	render: function(){
 		var self = this;
 		var x = this.state.data.map(function(d, index){
 			return <AssistantRow onDelete={self.handleDelete} stt={index+1} data={d} />
 		});
 		return (
 			<div>
 				<h4>Giảng viên:</h4>
 				<input type="hidden" id="ast" placeholder="Chọn giảng viên" style={{width:"500px"}} class="input-xlarge" />
				<button class="btn btn-success" onClick={this.handleAdd}>Thêm giảng viên</button>
	 			<div class="table-responsive">
	 				<table class="table table-bordered">
	 					<thead>
	 						<tr class="success">
	 							<td>Stt</td>
	 							<td>Username</td>
	 							<td>Giảng viên</td>
	 							<td>Mã giảng viên</td>
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
 	onDelete: function(){
 		this.props.onDelete(this.props.data);
 	},
 	render: function(){
 		return (
 			<tr>
 				<td>{this.props.stt}</td>
 				<td>{this.props.data.username}</td>
 				<td>{this.props.data.hovaten}</td>
 				<td>{this.props.data.code}</td>
 				<td><button class="btn btn-sm btn-danger" onClick={this.onDelete}>Xóa</button></td>
 			</tr>
 		);
 	}
 });