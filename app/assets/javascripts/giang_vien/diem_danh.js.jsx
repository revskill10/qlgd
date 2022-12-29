 /** @jsx React.DOM */

var mainData = [
	{id: 1, category: 'A'},
	{id: 2, category: 'B'},
	{id: 3, category: 'A'},
	{id: 4, category: 'C'},
	{id: 5, category: 'A'},
	{id: 6, category: 'B'},
	{id: 7, category: 'B'},
	{id: 8, category: 'C'},
];

 var DiemDanh = React.createClass({
 	getInitialState: function(){
 		return {data: []}
 	},
 	componentWillMount: function(){
 		this.setState({data: mainData});
 	},
 	componentDidMount: function(){
 		$('#container').mixItUp();
 	},
 	render: function(){
 		var x = this.state.data.map(function(d){
 			return <DiemDanhItem data={d} />
 		})
 		return (
 			<div>
 				<div class="controls">
				  <label>Filter:</label>
				  
				  <button class="filter" data-filter="all">All</button>
				  <button class="filter" data-filter=".A">A</button>
				  <button class="filter active" data-filter=".B">B</button>
				  <button class="filter active" data-filter=".C">C</button>
				  <label>Sort:</label>
				  
				  <button class="sort" data-sort="myorder:asc">Asc</button>
				  <button class="sort" data-sort="myorder:desc">Desc</button>
				</div>
	 			<div id="container" class="ctn">
	 				{x}
				</div> 			
			</div>
 		)
 	}
 });

 var DiemDanhItem = React.createClass({
 	getInitialState: function(){
 		return {data: this.props.data}
 	},
 	render: function(){
 		return (
 			<div class={"mix " + this.state.data.category} data-myorder={this.state.data.id}></div>
 		)
 	}
 });
 React.renderComponent(<DiemDanh />, document.getElementById('main'));