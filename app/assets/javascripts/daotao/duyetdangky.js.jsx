 /** @jsx React.DOM */

var ldata = [
	{id: 1, tuan: 1, thoi_gian: '6h30 12/08/2013', giang_vien: 'gv1', phong: 'phong', so_tiet: 3, alias_state:'Nghỉ dạy', type_status: 'Lý thuyết', note: 'om'},
	{id: 2, tuan: 1, thoi_gian: '6h30 12/08/2013', giang_vien: 'gv1', phong: 'phong', so_tiet: 3, alias_state:'Bổ sung', type_status: 'Lý thuyết', note: ''}
]

 var DuyetDangKy = React.createClass({
 	getInitialState: function(){
 		return {data: [], active: -1};
 	},
 	loadData: function(){
 		//this.setState({data: ldata});
 		$.ajax({
 			url: '/daotao/lich_trinh_giang_days',
 			success: function(data){
 				this.setState({data: data, active: -1});
 				React.renderComponent(<LichDaDuyet />, document.getElementById('lichdaduyet')); 
 			}.bind(this)
 		})
 	},
 	componentWillMount: function(){
 		this.loadData();
 	},
 	handleAccept: function(d){ 		
 		$.ajax({
	      url: "/daotao/lich_trinh_giang_days/accept",
	      type: 'POST',
	      data: d,
	      success: function(data) {             
	      	this.setState({data: data});
	      	React.unmountAndReleaseReactRootNode(document.getElementById('lichdaduyet'));
 			React.renderComponent(<LichDaDuyet />, document.getElementById('lichdaduyet'));  
	      }.bind(this)
	    });
 	},
 	handleDrop: function(d){
 		$.ajax({
	      url: "/daotao/lich_trinh_giang_days/drop",
	      type: 'POST',
	      data: d,
	      success: function(data) {             
	      	this.setState({data: data});  
	      	React.unmountAndReleaseReactRootNode(document.getElementById('lichdaduyet'));
 			React.renderComponent(<LichDaDuyet />, document.getElementById('lichdaduyet'));     
	      }.bind(this)
	    });
 	},
 	handleCheck: function(d){
 		this.setState({active: d.id});
 		React.unmountAndReleaseReactRootNode(document.getElementById('lichtrung'));
 		React.renderComponent(<LichTrung id={d.id} />, document.getElementById('lichtrung'));
 	},
 	render: function(){
 		var self = this;
 		var x = this.state.data.map(function(d, index){
 			return <LichDuyet key={d.id} active={self.state.active} onCheck={self.handleCheck} onAccept={self.handleAccept} onDrop={self.handleDrop} color={index % 2 === 0 ? 'warning' : 'danger'} data={d} />
 		});
 		return (
 		<div>
 			<div id="lichtrung">
 			</div>
 			<div class="table-responsive">
 				<h4>Danh sách lịch đăng ký</h4>
 				<table class="table table-bordered table-striped">
 					<thead>
 						<tr class="success">
 							<td>Tuần</td><td>Thời gian</td><td>Giảng viên</td><td>Phòng</td><td>Số tiết</td><td>Loại</td><td>Giờ học</td><td>Lí do</td><td>Thao tác</td>
 						</tr>
 					</thead>
 					<tbody>
 						{x}
 					</tbody>
 				</table>
 			</div>
 			<div id="lichdaduyet">
 			</div>
 		</div>
 		);
 	}
 });

 var LichDuyet = React.createClass({
 	onAccept: function(){
 		if (this.props.data.alias_state === 'Bổ sung'){
 			var phong = this.refs.phong.getDOMNode().value;
 			this.props.onAccept({id: this.props.data.id, phong: phong});
 		} else {
 			this.props.onAccept(this.props.data);
 		}
 		
 	},
 	onDrop: function(){
 		this.props.onDrop(this.props.data);
 	},
 	onCheck: function(){
 		this.props.onCheck(this.props.data);
 	},
 	componentDidMount: function(){
 		if (this.props.data.alias_state === 'Bổ sung'){
 			this.refs.phong.getDOMNode().value = this.props.data.phong;
 		}
 	},
 	render: function(){
 		return (
 			<tr class={this.props.active === this.props.data.id ? 'default' : this.props.color}>
 				<td>{this.props.data.tuan}</td>
 				<td>{this.props.data.thoi_gian}</td>
 				<td>{this.props.data.giang_vien}</td>
 				<td>{this.props.data.alias_state === 'Bổ sung' ? <input type="text" ref="phong" /> : this.props.data.phong }</td>
 				<td>{this.props.data.so_tiet}</td>
 				<td>{this.props.data.alias_state}</td>
 				<td>{this.props.data.type_status}</td>
 				<td>{this.props.data.note}</td>
 				<td><button class="btn btn-sm btn-danger" onClick={this.onDrop}>Không chấp nhận</button>
 				<button class="btn btn-sm btn-primary" onClick={this.onAccept}>Chấp nhận</button>
 				<button style={{display:this.props.data.alias_state === 'Bổ sung' ? '' : 'none'}} class="btn btn-sm btn-warning" onClick={this.onCheck}>Kiểm tra</button></td>
 			</tr>
 		);
 	}
 });

 var LichTrung = React.createClass({
 	getInitialState: function(){
 		return {data: [], sinh_vien: []}
 	},
 	componentWillMount: function(){
 		this.loadData();
 	},
 	loadData: function(){
 		$.ajax({
 			url: '/daotao/lich_trinh_giang_days/check',
 			data: {id: this.props.id},
 			type: 'POST',
 			success: function(data){
 				this.setState({data: data.lich, sinh_vien: data.sinh_vien});
 			}.bind(this)
 		})
 	},
 	render: function(){
 		var self = this;
 		var x = this.state.data.map(function(d, index){
 			return <tr class={index % 2 === 0 ? 'warning' : 'danger'}>
 				<td>{d.tuan}</td>
 				<td>{d.thoi_gian}</td>
 				<td>{d.giang_vien}</td>
 				<td>{d.phong}</td>
 				<td>{d.so_tiet}</td>
 				<td>{d.alias_state}</td>
 				<td>{d.type_status}</td>
 			</tr>
 		});
 		var sv = this.state.sinh_vien.map(function(d, index){
 			return <tr class={index % 2 === 0 ? 'warning' : 'danger'}>
 				<td>{index+1}</td>
 				<td>{d.code}</td>
 				<td>{d.hovaten}</td> 	
 				<td>{d.ma_lop_hanh_chinh}</td>			
 			</tr>
 		})
 		return (
 			<div>
	 			<div class="table-responsive">
	 			<h4>Danh sách lịch trùng</h4>
	 			<table class="table table-bordered table-striped">
					<thead>
						<tr class="success">
							<td>Tuần</td><td>Thời gian</td><td>Giảng viên</td><td>Phòng</td><td>Số tiết</td><td>Loại</td><td>Giờ học</td>
						</tr>
					</thead>
					<tbody>
						{x}
					</tbody>
				</table>
				</div>

				<div class="table-responsive">
	 			<h4>Danh sách sinh viên trùng</h4>
	 			<table class="table table-bordered table-striped">
					<thead>
						<tr class="success">
							<td>Stt</td><td>Mã sinh viên</td><td>Họ và tên</td><td>Mã lớp hành chính</td>
						</tr>
					</thead>
					<tbody>
						{sv}
					</tbody>
				</table>
				</div>
			</div>
 		);
 	}
 });

 var LichDaDuyet = React.createClass({
 	getInitialState: function(){
 		return {data: []}
 	},
 	componentWillMount: function(){
 		this.loadData();
 	},
 	loadData: function(){
 		$.ajax({
 			url: '/daotao/lich_trinh_giang_days/daduyet',
 			success: function(data){
 				this.setState({data: data});
 			}.bind(this)
 		})
 	},
 	render: function(){
 		var self = this;
 		var x = this.state.data.map(function(d, index){
 			return <tr class={index % 2 === 0 ? 'warning' : 'danger'}>
 				<td>{d.tuan}</td>
 				<td>{d.thoi_gian}</td>
 				<td>{d.giang_vien}</td>
 				<td>{d.phong}</td>
 				<td>{d.so_tiet}</td>
 				<td>{d.alias_state}</td>
 				<td>{d.type_status}</td>
 				<td>{d.alias_status}</td>
 				<td>{d.updated_alias}</td>
 			</tr>
 		});
 		return (
 			<div class="table-responsive">
 			<h4>Danh sách lịch đã duyệt</h4>
 			<table class="table table-bordered table-striped">
				<thead>
					<tr class="success">
						<td>Tuần</td><td>Thời gian</td><td>Giảng viên</td><td>Phòng</td><td>Số tiết</td><td>Loại</td><td>Giờ học</td><td>Trạng thái</td><td>Ngày duyệt</td>
					</tr>
				</thead>
				<tbody>
					{x}
				</tbody>
			</table>
			</div>
 		);
 	}
 });