/** @jsx React.DOM */

var hdata = [
	{tuan: 1, colapse: 'colapseOne', active: false, data: [
			{id: 1, thoi_gian: '6h30 12/08/2013', phong: 'A103', so_tiet: 3, ma_lop: 'ml', ten_mon_hoc: 'tm', alias_state: 'Bình thường', alias_status: 'Đang chờ', color: 'warning'},
			{id: 2, thoi_gian: '6h30 12/08/2013', phong: 'A103', so_tiet: 3, ma_lop: 'ml', ten_mon_hoc: 'tm', alias_state: 'Bình thường', alias_status: 'Được chấp nhận'. color: 'info'},
			{id: 3, thoi_gian: '6h30 12/08/2013', phong: 'A103', so_tiet: 3, ma_lop: 'ml', ten_mon_hoc: 'tm', alias_state: 'Bình thường', alias_status: 'Đang chờ'}
		]},
	{tuan: 2, colapse: 'colapseTwo', active: true, data: [
			{id: 4, thoi_gian: '6h30 12/08/2013', phong: 'A103', so_tiet: 3, ma_lop: 'ml', ten_mon_hoc: 'tm', alias_state: 'Bình thường', alias_status: 'Đang chờ'},
			{id: 5, thoi_gian: '6h30 12/08/2013', phong: 'A103', so_tiet: 3, ma_lop: 'ml', ten_mon_hoc: 'tm', alias_state: 'Bình thường', alias_status: 'Đang chờ'}
		]},
	{tuan: 3, colapse: 'colapseThree', active: false, data: [
			{id: 6, thoi_gian: '6h30 12/08/2013', phong: 'A103', so_tiet: 3, ma_lop: 'ml', ten_mon_hoc: 'tm', alias_state: 'Bình thường', alias_status: 'Đang chờ'}
		]}
];
var Home2 = React.createClass({
	getInitialState: function(){
		return {data: []};
	},
	loadData: function(){
		this.setState({data: hdata});
	},
	componentWillMount: function(){
		this.loadData();
	},	
	render: function(){
		var self = this;
		var x = this.state.data.map(function(d){
			return <Tuan colapse={d.colapse} active={d.active} key={d.tuan} tuan={d.tuan} data={d.data} />;
		});
		return (
			<div class="panel-group" id="accordion">
			    {x}
			</div>

		);
	}
});

var Tuan = React.createClass({
	render: function(){
		return(
			<div class="panel panel-default">
    <div class="panel-heading">
      <h4 class="panel-title">
        <a data-toggle="collapse" data-parent="#accordion" href={"#"+this.props.colapse}>
          {"Tuần " + this.props.tuan}
        </a>
      </h4>
    </div>
    <div id={this.props.colapse} class={"panel-collapse collapse " + (this.props.active === true ? 'in' : '')}>
      <div class="panel-body">
        Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.
      </div>
    </div>
  </div>
		);
	}
});

React.renderComponent(<Home2 />, document.getElementById('main'));