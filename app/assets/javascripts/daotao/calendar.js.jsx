 /** @jsx React.DOM */

var DaotaoCalendar = React.createClass({
	getInitialState: function(){
		return {data: []}
	},
	loadData: function(){
		$.ajax({
 			url: '/daotao/lops',
 			success: function(data){ 				
 				this.setState({data: data.t});
 			}.bind(this)
 		})
	},
	componentWillMount: function(){
		this.loadData();
	},
	componentDidUpdate: function(){
		var self = this;
		$("#timlopcalendar").select2({
			data: self.state.data
		});
	},
	onSearch: function(){
		var lop_id = $('#timlopcalendar').val();
		React.unmountAndReleaseReactRootNode(document.getElementById('cc'));		
		React.renderComponent(<CalendarComponent lop_id={lop_id} />, document.getElementById('cc'));	
	},
	render: function(){
		return (
			<div><hr />
			<input type="hidden" id="timlopcalendar" placeholder="Lớp môn học" style={{width:"500px"}} class="input-xlarge" />
			<button class="btn btn-success" onClick={this.onSearch}>Tìm lớp</button>
			<hr />			
			<div id="cc"></div>
			</div>
		);
	}
});
var tdata = {
	tuans: [23, 24, 25, 30, 31, 32, 33],
	headers: [23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38]	
};
var CalendarComponent = React.createClass({
	getInitialState: function(){
		return {tuans: [], headers: [], calendars: []}
	},
	loadData: function(){
		$.ajax({
			url: '/daotao/lop_mon_hocs/' + this.props.lop_id + '/calendars',
			success: function(data){
				this.setState({tuans: data.tuans, headers: data.headers, calendars: data.calendars});
			}.bind(this)
		})
	},
	componentWillMount: function(){
		this.loadData();
	},
	handleDelete: function(d){
		$.ajax({
			url: '/daotao/lop_mon_hocs/' + this.props.lop_id + '/calendars/delete',
			type: 'POST',
			data: d,
			success: function(data){
				this.setState({tuans: data.tuans, headers: data.headers, calendars: data.calendars});
			}.bind(this)
		})
	},
	render: function(){
		var self = this;
		var headers = this.state.headers.map(function(d){
			return <td>{d}</td>
		});		
		var data = this.state.headers.map(function(d){
			if (self.state.tuans.indexOf(d) >= 0){
				return <td class="success">H</td>
			} else {
				return <td>_</td>
			}
		});
		var calendars = this.state.calendars.map(function(d){
			return <DaotaoCalendarRow onDelete={self.handleDelete} data={d} />
		});
		return (
			<div>
			<h4>Thời khóa biểu</h4>
			<div class="table-responsive">
				<table class="table tabled-bordered">
					<thead>
						<tr class="success">
							<td>Tuần học bắt đầu</td>
							<td>Số tuần</td>
							<td>Thứ</td>
							<td>Tiết bắt đầu</td>
							<td>Số tiết</td>
							<td>Phòng</td>
							<td>Giảng viên</td>							
							<td>Thao tác</td>
						</tr>
					</thead>
					<tbody>

					</tbody>
				</table>
			</div>
			<div class="table-responsive">
				<table class="table tabled-bordered">
					<thead>
						<tr class="success">
							<td>Tuần học bắt đầu</td>
							<td>Số tuần</td>
							<td>Thứ</td>
							<td>Tiết bắt đầu</td>
							<td>Số tiết</td>
							<td>Phòng</td>
							<td>Giảng viên</td>
							<td>Trạng thái</td>
							<td>Thao tác</td>
						</tr>
					</thead>
					<tbody>
						{calendars}
					</tbody>
				</table>
			</div>
			<hr />
			<div class="table-responsive">
				<table class="table tabled-bordered">
					<thead>
						<tr class="danger">{headers}</tr>
					</thead>
					<tbody>
						<tr>{data}</tr>
					</tbody>
				</table>
			</div>
			</div>
		)
	}
});
var DaotaoCalendarRow = React.createClass({
	onDelete: function(){
		this.props.onDelete(this.props.data);
	},
	render: function(){
		return (
			<tr>
				<td>{this.props.data.tuan_hoc_bat_dau}</td>
				<td>{this.props.data.so_tuan}</td>
				<td>{this.props.data.thu}</td>
				<td>{this.props.data.tiet_bat_dau}</td>
				<td>{this.props.data.so_tiet}</td>
				<td>{this.props.data.phong}</td>
				<td>{this.props.data.giang_vien}</td>
				<td>{this.props.data.state}</td>
				<td>
					<button style={{"display": this.props.data.can_generate === true ? '' : 'none'}} class="btn btn-sm btn-success" onClick={this.onGenerate}>Duyệt thực hiện</button>
					<button style={{"display": this.props.data.can_remove === true ? '' : 'none'}} class="btn btn-sm btn-danger" onClick={this.onDelete}>Xóa</button>
					<button style={{"display": this.props.data.can_restore === true ? '' : 'none'}} class="btn btn-sm btn-default" onClick={this.onRestore}>Phục hồi</button>					
				</td>
			</tr>
		);
	}
});