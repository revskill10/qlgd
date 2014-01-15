 /** @jsx React.DOM */

var ldata = [
	{tuan: 1, thoi_gian: '6h30 12/08/2013', giang_vien: 'gv1', phong: 'phong', so_tiet: 3, alias_state:'Nghỉ dạy', type_status: 'Lý thuyết', note: 'om'},
	{tuan: 1, thoi_gian: '6h30 12/08/2013', giang_vien: 'gv1', phong: 'phong', so_tiet: 3, alias_state:'Bổ sung', type_status: 'Lý thuyết', note: ''}
]

 var DuyetDangKy = React.createClass({
 	getInitialState: function(){
 		return {data: []};
 	},
 	loadData: function(){
 		this.setState({data: ldata});
 	},
 	componentWillMount: function(){
 		this.loadData();
 	},
 	handleAccept: function(d){

 	},
 	handleDrop: function(d){

 	},
 	render: function(){
 		var self = this;
 		var x = this.state.data.map(function(d, index){
 			return <LichDuyet color={index % 2 === 0 ? 'warning' : 'danger'} data={d} />
 		});
 		return (
 			<div class="table-responsive">
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
 		);
 	}
 });

 var LichDuyet = React.createClass({
 	render: function(){
 		return (
 			<tr class={this.props.color}>
 				<td>{this.props.data.tuan}</td>
 				<td>{this.props.data.thoi_gian}</td>
 				<td>{this.props.data.giang_vien}</td>
 				<td>{this.props.data.phong}</td>
 				<td>{this.props.data.so_tiet}</td>
 				<td>{this.props.data.alias_state}</td>
 				<td>{this.props.data.type_status}</td>
 				<td>{this.props.data.note}</td>
 				<td><button class="btn btn-sm btn-danger" onClick={this.onDrop}>Không chấp nhận</button>
 				<button class="btn btn-sm btn-primary" onClick={this.onAccept}>Chấp nhận</button></td>
 			</tr>
 		);
 	}
 });