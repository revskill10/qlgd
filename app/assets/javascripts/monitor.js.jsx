/** @jsx React.DOM */

var Monitor = React.createClass({
	getInitialState: function(){
		return {data: []}
	},
	componentWillMount: function(){
		this.loadData();
	},
	loadData: function(){
		$.ajax({
			url: '/monitor',
			success: function(data){
				this.setState({data: data});
			}.bind(this)
		})
	},
	render: function(){
		var x = this.state.data.map(function(d){
			return <MonitorRow data={d} />
		});
		return (
			<div class="table-responsive">
 				<table class="table table-bordered">
 					<thead>
 						<td>Tuần</td><td>Thời gian</td><td>Tiết bắt đầu</td><td>Phòng</td><td>Giảng viên</td><td>Số tiết</td><td>Thực hành</td><td>Loại</td><td>Trạng thái</td><td>Thao tác</td>
 					</thead>
 					<tbody>
 						{x}
 					</tbody>
 				</table>
 			</div>
		)
	}
});

var MonitorRow = React.createClass({
	render: function(){
		return (
			<tr>
				<td>{this.props.data.tuan}</td>
				<td>{this.props.data.thoi_gian}</td>
				<td>{this.props.data.tiet_bat_dau}</td>
				<td>{this.props.data.phong}</td>
				<td>{this.props.data.giang_vien}</td>
				<td>{this.props.data.so_tiet}</td>
				<td>{this.props.data.thuc_hanh}</td>
				<td>{this.props.data.alias_state}</td>
				<td>{this.props.data.alias_status}</td>
			</tr>
		);
	}
});

