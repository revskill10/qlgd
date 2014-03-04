/** @jsx React.DOM */

var TKLichTrinh = React.createClass({
	getInitialState: function(){
		return {data: []}
	},
	loadData: function(){
		$.ajax({
			url: '/truongkhoa/lop/' + this.props.lop_id + '/lichtrinh',
			method: 'GET',
			success: function(data){
				this.setState({data: data});
			}.bind(this)
		});
	},
	componentWillMount: function(){
		this.loadData();
	},
	render: function(){
		var self = this;
		var x = this.state.data.map(function(d, index){
			return <tr class={index % 2 === 0 ? 'danger' : 'warning'}>
				<td>{d.tuan}</td>
				<td>{d.noi_dung}</td>
				<td>{d.so_tiet}</td>
				<td>{d.thoi_gian}</td>
			</tr>
		});
		return (
			<div class="table-responsive">
				<table class="table table-bordered">
					<thead>
						<tr class="success">
							<td>Tuần</td>						
							<td>Nội dung</td>
							<td>Số tiết</td>						
							<td>Thời gian</td>
						</tr>
					</thead>
					<tbody>
						{x}
					</tbody>
				</table>
			</div>
		)
	}
});

var Lop = React.createClass({
	getInitialState: function(){
		return {data: {}, lichtrinhs: []}
	},
	loadData: function(){
		$.ajax({
			url: '/truongkhoa/lop/' + this.props.lop_id,
			method: 'GET',
			success: function(data){
				this.setState({data: data})
			}.bind(this)
		});		
	},
	componentWillMount: function(){
		this.loadData();				
	},
	updateInfo: function(type, action){
		// 1: thong so, 2: lich trinh, 3: tinh hinh
		// action: true(approve), false(reject)
		$.ajax({
			url: '/truongkhoa/update', 
			method: 'POST',
			data: {lop_id: this.props.lop_id, type: type, maction: action},
			success: function(data){
				this.setState({data: data});				
			}.bind(this)
		})
	},
	onApproveThongSo: function(){
		this.updateInfo(1, 1);
	},
	onRejectThongSo: function(){
		this.updateInfo(1, 0);
	},
	onApproveLichTrinh: function(){
		this.updateInfo(2, 1);
	},
	onRejectLichTrinh: function(){
		this.updateInfo(2, 0);
	},
	onApproveTinhHinh: function(){
		this.updateInfo(3, 1);
	},
	onRejectTinhHinh: function(){
		this.updateInfo(3, 0);
	},
	render: function(){
		return (
			<div>
				<div class="table-responsive">
					<table class="table table-bordered">
						<thead>
							<tr class="success">
								<td>Giảng viên</td>
								<td>Mã lớp</td>
								<td>Tên môn học</td>
								<td>Duyệt đề cương</td>
								<td>Duyệt lịch trình</td>
								<td>Duyệt tình hình</td>
							</tr>
						</thead>
						<tbody>
							<tr class="success">
								<td>{this.state.data.giang_viens}</td>
								<td>{this.state.data.ma_lop}</td>
								<td>{this.state.data.ten_mon_hoc}</td>
								<td>{this.state.data.duyet_thong_so_status}</td>
								<td>{this.state.data.duyet_lich_trinh_status}</td>
								<td>{this.state.data.duyet_tinh_hinh_status}</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="panel-group" id="accordion">
					<div class="panel panel-default">
						<div class="panel-heading">
					      <h4 class="panel-title">
					        <a data-toggle="collapse" data-parent="#accordion" href="#dcct">
					          Đề cương chi tiết
					        </a>
					      </h4>
					    </div>
					    <div id="dcct" class="panel-collapse collapse">
						    <div class="panel-body">
						      	<button class="btn btn-sm btn-primary" style={{display: this.state.data.can_approve_thong_so === false ?  'none' : ''}} onClick={this.onApproveThongSo}>Duyệt</button>
								<button class="btn btn-sm btn-warning" style={{display: this.state.data.can_reject_thong_so === false ?  'none' : ''}} onClick={this.onRejectThongSo}>Không duyệt</button>
								<hr/>
								<span dangerouslySetInnerHTML={{__html: this.state.data.de_cuong_chi_tiet_html }} />
							</div>
					    </div>
					</div>			
					<div class="panel panel-default">
					    <div class="panel-heading">
					      <h4 class="panel-title">
					        <a data-toggle="collapse" data-parent="#accordion" href="#ltth">
					          Lịch trình thực hiện
					        </a>
					      </h4>
					    </div>
					    <div id="ltth" class="panel-collapse collapse">
						      <div class="panel-body">
						      	<button class="btn btn-sm btn-primary" style={{display: this.state.data.can_approve_lich_trinh === false ?  'none' : ''}} onClick={this.onApproveLichTrinh}>Duyệt</button>
								<button class="btn btn-sm btn-warning" style={{display: this.state.data.can_reject_lich_trinh === false ?  'none' : ''}} onClick={this.onRejectLichTrinh}>Không duyệt</button>
								<hr/>
								<TKLichTrinh lop_id={this.props.lop_id} />							
						      </div>
					    </div>
					</div>
					<div class="panel panel-default">
					    <div class="panel-heading">
					      <h4 class="panel-title">
					        <a data-toggle="collapse" data-parent="#accordion" href="#thht">
					          Tình hình học tập
					        </a>
					      </h4>
					    </div>
					    <div id="thht" class="panel-collapse collapse">
						      <div class="panel-body">
						      		<button class="btn btn-sm btn-primary" style={{display: this.state.data.can_approve_tinh_hinh === false ?  'none' : ''}} onClick={this.onApproveTinhHinh}>Duyệt</button>
									<button class="btn btn-sm btn-warning" style={{display: this.state.data.can_reject_tinh_hinh === false ?  'none' : ''}} onClick={this.onRejectTinhHinh}>Không duyệt</button>
									<hr/>
									Tình hình học tập
						      </div>
					    </div>
					</div>
				</div>	
			</div>
		)
	}
});
React.renderComponent(<Lop lop_id={ENV.lop_id} />, document.getElementById('tkmain'));