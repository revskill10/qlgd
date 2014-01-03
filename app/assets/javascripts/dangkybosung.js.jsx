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
	loadData: function(){
		$.ajax({
          url: "/lop/"+this.props.lop+"/"+this.props.giang_vien +"/lich_trinh_giang_days/bosung" ,
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
			var thuc_hanh = this.refs.thuc_hanh.getDOMNode().value;
			var data = {giang_vien: this.props.giang_vien,thoi_gian: thoi_gian, tiet_bat_dau: tiet_bat_dau, phong: phong, so_tiet: so_tiet, thuc_hanh: thuc_hanh};
			$.ajax({
            url: "/lop/" + this.props.lop + "/lich_trinh_giang_days",
	            type: 'POST',
	            data: data,
	            success: function(data) {             
	                this.setState({data: data, add: 0}); 
	            }.bind(this)           
	        });			
		}
		
		return false;
	},
	onCancelAdd: function(){
		this.setState({add: 0});
	},
	componentDidUpdate: function(){
		if (this.state.add == 1) {
			$('.input-append.date').datepicker({
				format: "dd/mm/yyyy",
				startDate: "8/1/2014",
				todayBtn: "linked",
	    		language: "vi",
	    		autoClose: true,
	    		todayHighlight: true
	    	});
		}
	},
	render: function(){
		var x = this.state.data.map(function(d){
			return <Row2 data={d} />
		});		
		if (this.state.add === 0) {
			return (
				<div>
					<br />
					<button class="btn btn-sm btn-success" onClick={this.onAdd} >Đăng ký bổ sung</button>
					<div class="table-responsive">
						<table class="table table-bordered">
							<thead>
								<th>Stt</th>
								<th>Thời gian</th>
								<th>Tiết bắt đầu</th>
								<th>Số tiết</th>
								<th>Phòng</th>
								<th>Thực hành</th>
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
								<th>Thực hành</th>
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
										<option value="14">14 (16h45)</option>
										<option value="15">15 (16h45)</option>
										<option value="16">16 (16h45)</option>
									</select>
								</td>
								<td>
									<input type="text" ref="so_tiet" placeholder="Số tiết dạy" class="form-control input-sm" />
								</td>
								<td>
									<input type="text" placeholder="Phòng" ref="phong" class="form-control input-sm" />
								</td>
								<td>
									<select ref="thuc_hanh" class="form-control input-sm">
										<option value="false">Lý thuyết</option>
										<option value="true">Thực hành</option>
									</select>
								</td>								
								<td>
									<button class="btn btn-sm btn-success" onClick={this.onCancelAdd} >Hủy</button>
									<button class="btn btn-sm btn-success" onClick={this.onSubmitAdd} >Cập nhật</button>
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
								<th>Thực hành</th>
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
			var thuc_hanh = this.refs.thuc_hanh.getDOMNode().value;

			alert(tiet_bat_dau + '\n' + thoi_gian + '\n' + phong + '\n' + so_tiet + '\n' + thuc_hanh);
			this.setState({edit: 0});
		}
		
		return false;
	},
	componentDidUpdate: function(){
		if (this.state.edit == 1){
			this.refs.thoi_gian.getDOMNode().value = this.props.data.thoi_gian;
			this.refs.tiet_bat_dau.getDOMNode().value = this.props.data.tiet_bat_dau;
			this.refs.so_tiet.getDOMNode().value = this.props.data.so_tiet;
			this.refs.phong.getDOMNode().value = this.props.data.phong;	
			this.refs.thuc_hanh.getDOMNode().value = this.props.data.thuc_hanh;
			$('.input-append.date').datepicker({
				format: "dd/mm/yyyy",
				startDate: "8/1/2014",
				todayBtn: "linked",
	    		language: "vi",
	    		autoClose: true,
	    		todayHighlight: true
	    	});
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
				<td>{this.props.data.thuc_hanh === false ? "Lý thuyết" : "Thực hành"}</td>
				<td>{this.props.data.status}</td>
				<td><button class="btn btn-sm btn-success" onClick={this.onClickEdit}>Edit</button></td>
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
							<option value="14">14 (16h45)</option>
							<option value="15">15 (16h45)</option>
							<option value="16">16 (16h45)</option>
						</select>
					</td>
					<td>
						<input type="text" ref="so_tiet" class="form-control input-sm" />
					</td>
					<td>
						<input type="text" ref="phong" class="form-control input-sm" />
					</td>
					<td>
						<select ref="thuc_hanh" class="form-control input-sm">
							<option value="false">Lý thuyết</option>
							<option value="true">Thực hành</option>
						</select>
					</td>
					<td>
						{this.props.data.status}
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