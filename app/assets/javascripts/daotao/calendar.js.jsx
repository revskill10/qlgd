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
		return {tuans: [], headers: [], calendars: [], giang_viens: [], phongs: []}
	},
	loadData: function(){
		$.ajax({
			url: '/daotao/lop_mon_hocs/' + this.props.lop_id + '/calendars',
			success: function(data){
				this.setState({tuans: data.tuans, headers: data.headers, calendars: data.calendars, giang_viens: data.giang_viens, phongs: data.phongs});
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
				this.setState({tuans: data.tuans, headers: data.headers, calendars: data.calendars, giang_viens: data.giang_viens, phongs: data.phongs});
			}.bind(this)
		})
	},
	handleGenerate: function(d){
		$.ajax({
			url: '/daotao/lop_mon_hocs/' + this.props.lop_id + '/calendars/generate',
			type: 'POST',
			data: d,
			success: function(data){
				this.setState({tuans: data.tuans, headers: data.headers, calendars: data.calendars, giang_viens: data.giang_viens, phongs: data.phongs});
			}.bind(this)
		})
	},
	handleRestore: function(d){
		$.ajax({
			url: '/daotao/lop_mon_hocs/' + this.props.lop_id + '/calendars/restore',
			type: 'POST',
			data: d,
			success: function(data){
				this.setState({tuans: data.tuans, headers: data.headers, calendars: data.calendars, giang_viens: data.giang_viens, phongs: data.phongs});
			}.bind(this)
		})
	},
	handleAdd: function(d){		
		$.ajax({
			url: '/daotao/lop_mon_hocs/' + this.props.lop_id + '/calendars/add',
			type: 'POST',
			data: d,
			success: function(data){
				this.setState({tuans: data.tuans, headers: data.headers, calendars: data.calendars, giang_viens: data.giang_viens, phongs: data.phongs});
			}.bind(this)
		})
	},
	componentDidUpdate: function(){
		React.unmountAndReleaseReactRootNode(document.getElementById('tc'));		
		React.renderComponent(<TaoCalendar giang_viens={this.state.giang_viens} phongs={this.state.phongs} onAdd={this.handleAdd} />, document.getElementById('tc'));		
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
			return <DaotaoCalendarRow onDelete={self.handleDelete} onGenerate={self.handleGenerate} onRestore={self.handleRestore} data={d} />
		});
		return (
			<div>
			<h4>Tạo thời khóa biểu</h4>
			<div id="tc"></div>
			<hr />
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
var TaoCalendar = React.createClass({
	range: function(start, end) {
	    var foo = [];
	    for (var i = start; i <= end; i++) {
	        foo.push(i);
	    }
	    return foo;
	},
	onAdd: function(){
		var tuan_hoc_bat_dau = this.refs.tuan_hoc_bat_dau.getDOMNode().value;
		var so_tuan = this.refs.so_tuan.getDOMNode().value;
		var thu = this.refs.thu.getDOMNode().value;
		var tiet_bat_dau = this.refs.tiet_bat_dau.getDOMNode().value;
		var so_tiet = this.refs.so_tiet.getDOMNode().value;
		var phong = this.refs.phong.getDOMNode().value;
		var giang_vien_id = this.refs.giang_vien.getDOMNode().value;
		var data = {			
			tuan_hoc_bat_dau: tuan_hoc_bat_dau,
			so_tuan: so_tuan,
			thu: thu,
			tiet_bat_dau: tiet_bat_dau,
			so_tiet: so_tiet,
			phong: phong,
			giang_vien_id: giang_vien_id
		}
		this.props.onAdd(data);
	},		
	render: function(){
		var tuans = this.range(23, 42);
		var sotuans = this.range(1, 16);
		var sotiets = this.range(1, 6);
		var ttuans = tuans.map(function(d){
			return <option value={d}>{d}</option>
		});
		var tsotuans = sotuans.map(function(d){
			return <option value={d}>{d}</option>
		});
		var tsotiets = sotiets.map(function(d){
			return <option value={d}>{d}</option>
		});
		var giang_viens = this.props.giang_viens.map(function(d){
			return <option value={d.id}>{d.text}</option>
		});
		var phongs = this.props.phongs.map(function(d){
			return <option value={d.id}>{d.text}</option>
		});
		return (
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
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>								
								<select ref="tuan_hoc_bat_dau" class="form-control input-sm">
									{ttuans}
								</select>
							</td>
							<td>
								<select ref="so_tuan" class="form-control input-sm">
									{tsotuans}
								</select>
							</td>
							<td>								
								<select ref="thu" class="form-control input-sm">
									<option value="2">Thứ hai</option>
									<option value="3">Thứ ba</option>
									<option value="4">Thứ tư</option>
									<option value="5">Thứ năm</option>
									<option value="6">Thứ sáu</option>
									<option value="7">Thứ bảy</option>
									<option value="8">Chủ nhật</option>
								</select>
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
								<select ref="so_tiet" class="form-control input-sm">
									{tsotiets}
								</select>
							</td>
							<td>
								<select ref="phong" class="form-control input-sm">
									{phongs}
								</select>
							</td>
							<td>								
								<select ref="giang_vien" class="form-control input-sm">
									{giang_viens}
								</select>
							</td>							
						</tr>
					</tbody>
				</table>
				<button onClick={this.onAdd} class="btn btn-sm btn-success">Thêm</button>
			</div>
		);
	}
});
var DaotaoCalendarRow = React.createClass({
	onDelete: function(){
		this.props.onDelete(this.props.data);
	},
	onGenerate: function(){
		this.props.onGenerate(this.props.data);
	},
	onRestore: function(){
		this.props.onRestore(this.props.data);
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
					<button style={{"display": this.props.data.can_generate === true ? '' : 'none'}} class="btn btn-sm btn-primary" onClick={this.onGenerate}>Duyệt thực hiện</button>
					<button style={{"display": this.props.data.can_remove === true ? '' : 'none'}} class="btn btn-sm btn-danger" onClick={this.onDelete}>Xóa</button>
					<button style={{"display": this.props.data.can_restore === true ? '' : 'none'}} class="btn btn-sm btn-default" onClick={this.onRestore}>Phục hồi</button>					
				</td>
			</tr>
		);
	}
});