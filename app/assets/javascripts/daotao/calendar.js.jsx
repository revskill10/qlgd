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
			<h4>Thời khóa biểu</h4>
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
	render: function(){
		var headers = tdata.headers.map(function(d){
			return <td>{d}</td>
		});		
		var data = tdata.headers.map(function(d){
			if (tdata.tuans.indexOf(d) >= 0){
				return <td class="danger">x</td>
			} else {
				return <td>_</td>
			}
		});
		return (
			<div class="table-responsive">
				<table class="table tabled-bordered">
					<thead>
						<tr class="success">{headers}</tr>
					</thead>
					<tbody>
						<tr>{data}</tr>
					</tbody>
				</table>
			</div>
		)
	}
});