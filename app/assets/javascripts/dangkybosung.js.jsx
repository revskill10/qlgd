/** @jsx React.DOM */


var MDATA = [
	{id: 1, thoi_gian: '12/08/2013', tiet_bat_dau: 1, phong: 'A101', status: ''},
	{id: 2, thoi_gian: '19/08/2013', tiet_bat_dau: 2, phong: 'A103'}
];


var Bosung = React.createClass({
	loadData: function(){
		this.setState({data: MDATA, add: 0});
	},
	componentWillMount: function(){
		this.loadData();
	},
	onAdd: function(){
		this.setState({add: 1});
	},
	render: function(){
		var x = this.state.data.map(function(d){
			return <Row2 data={d} />
		});		
		if (this.state.add === 0) {
			return (
				<div>
				<button onClick={this.onAdd} >Add</button>
				<table class="table table-bordered">
					<thead>
						<th>Stt</th><th>Thoi gian</th><th>Tiet bat dau</th><th>Phong</th>
					</thead>
					<tbody>
						{x}
					</tbody>
				</table>
				</div>
			);
		} else if (this.state.add === 1) {
			return (
				<div>
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
		var tiet_bat_dau = this.refs.tiet_bat_dau.getDOMNode().value;
		var thoi_gian = this.refs.thoi_gian.getDOMNode().value;
		var phong = this.refs.phong.getDOMNode().value;
		alert(tiet_bat_dau + thoi_gian + phong);

		this.setState({edit: 0});
		return false;
	},
	componentDidUpdate: function(){
		this.refs.thoi_gian.getDOMNode().value = this.props.data.thoi_gian;
		this.refs.tiet_bat_dau.getDOMNode().value = this.props.data.tiet_bat_dau;
		this.refs.phong.getDOMNode().value = this.props.data.phong;
		$('.input-append.date').datepicker({
			format: "dd/mm/yyyy",
			startDate: "8/1/2014",
			todayBtn: "linked",
    		language: "vi",
    		autoClose: true,
    		todayHighlight: true
    	});
	},
	render: function(){

		if (this.state.edit === 0) {
			return (
				<tr><td>{this.props.data.id}</td>
				<td>{this.props.data.thoi_gian}</td>
				<td>{this.props.data.tiet_bat_dau}</td>
				<td>{this.props.data.phong}</td>
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
						</select>
					</td>
					<td>
						<input type="text" ref="phong" class="form-control input-sm" />
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