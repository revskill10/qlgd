 /** @jsx React.DOM */
        
        var DATA = [
                {assignment_group_id: 1, name: 'BT1', weight: 50, assignments:
                                [
                                        {assignment_id: 1, name: 'BT11', points: 10},
                                        {assignment_id: 2,name: 'BT12', points: 8}
                                ]
                },
                {assignment_group_id: 2, name: 'BT2', weight: 50, assignments:
                                [
                                        {assignment_id: 3, name: 'BT21', points: 9},
                                        {assignment_id: 4,name: 'BT22', points: 8}
                                ]}
                ];
        var Assignments = React.createClass({
                getInitialState: function(){
                    return {data: [], add: 0};                        
                },                                
                loadData: function(){
                    $.ajax({
                        url: "/lop/" + this.props.lop + "/assignments.json",
                        success: function(data) {
                            data.forEach(function(d){
                                if (d.assignments != null && d.assignments.length > 0) {
                                    d.assignments.map(function(d2){
                                        d2.edit = 0;
                                        return d2;
                                    });                                
                                }
                            });        
                            this.setState({data: data, add: 0});
                            React.unmountAndReleaseReactRootNode(document.getElementById('grades'));
                            React.renderComponent(<Grade lop={this.props.lop} />,
                                document.getElementById("grades"));
                        }.bind(this)
                    });             
                },
                componentWillMount: function(){
                    this.loadData();
                },
                
                handleEdit: function(obj){                    
                    obj._method = "put"
                    $.ajax({
                        url: "/lop/" + this.props.lop + "/assignment_groups",
                        type: 'POST',
                        data: obj,
                        success: function(data) {
                            data.forEach(function(d){
                                if (d.assignments != null && d.assignments.length > 0) {
                                    d.assignments.map(function(d2){
                                        d2.edit = 0;
                                        return d2;
                                    });                                
                                }
                            });        
                            this.setState({data: data, add: 0});
                            React.unmountAndReleaseReactRootNode(document.getElementById('grades'));
                            React.renderComponent(<Grade lop={this.props.lop} />,
                                document.getElementById("grades"));
                        }.bind(this)
                    });       
                    
                },
                handleUpdate: function(d){                        
                    d._method = "put";
                    $.ajax({
                      url: "/lop/" + this.props.lop + "/assignments",
                      type: 'POST',
                      data: d,
                      success: function(data) {             
                            data.forEach(function(d){
                                if (d.assignments != null && d.assignments.length > 0) {
                                    d.assignments.map(function(d2){
                                        d2.edit = 0;
                                        return d2;
                                    });                                
                                }
                            });        
                            this.setState({data: data, add: 0}); 
                            React.unmountAndReleaseReactRootNode(document.getElementById('grades'));
                            React.renderComponent(<Grade lop={this.props.lop} />,
                        document.getElementById("grades"));
                      }.bind(this)
                    });    
                    return false;
                },
                enableAdd: function(e){
                        this.state.add = 1;
                        this.forceUpdate();
                },
                cancelAdd: function(e){
                        this.state.add = 0;
                        this.forceUpdate();
                },
                onAdd: function(e){
                        var name = this.refs.name.getDOMNode().value;
                        var weight = this.refs.weight.getDOMNode().value;
                        var d = {
                                lop_id: this.props.lop_id,
                                giang_vien_id: this.props.giang_vien,
                                name: name,
                                weight: weight
                        }
                        $.ajax({
                          url: "/lop/" + this.props.lop + "/assignment_groups",
                          type: 'POST',
                          data: d,
                          success: function(data) {             
                                data.forEach(function(d){
                                    if (d.assignments != null && d.assignments.length > 0) {
                                        d.assignments.map(function(d2){
                                            d2.edit = 0;
                                            return d2;
                                        });                                
                                    }
                                });        
                                this.setState({data: data, add: 0}); 
                                React.unmountAndReleaseReactRootNode(document.getElementById('grades'));
                                React.renderComponent(<Grade lop={this.props.lop} />,
                                    document.getElementById("grades"));
                          }.bind(this)
                        });
                        return false;
                },
                handleDelete: function(assignment_group){
                    var d = {assignment_group_id: assignment_group.assignment_group_id, "_method":"delete"};
                    $.ajax({
                      url: "/lop/" + this.props.lop + "/assignment_groups",
                      type: 'POST',
                      data: d,
                      success: function(data) {             
                            data.forEach(function(d){
                                if (d.assignments != null && d.assignments.length > 0) {
                                    d.assignments.map(function(d2){
                                        d2.edit = 0;
                                        return d2;
                                    });                                
                                }
                            });        
                            this.setState({data: data, add: 0}); 
                            React.unmountAndReleaseReactRootNode(document.getElementById('grades'));
                            React.renderComponent(<Grade lop={this.props.lop} />,
                                    document.getElementById("grades"));
                      }.bind(this)
                    });
                },
                handleAssignmentDelete: function(assignment){
                    var d = {assignment_id: assignment.assignment_id, "_method":"delete"};
                    $.ajax({
                      url: "/lop/" + this.props.lop + "/assignments",
                      type: 'POST',
                      data: d,
                      success: function(data) {             
                            data.forEach(function(d){
                                if (d.assignments != null && d.assignments.length > 0) {
                                    d.assignments.map(function(d2){
                                        d2.edit = 0;
                                        return d2;
                                    });                                
                                }
                            });        
                            this.setState({data: data, add: 0}); 
                            React.unmountAndReleaseReactRootNode(document.getElementById('grades'));
                            React.renderComponent(<Grade lop={this.props.lop} />,
                                    document.getElementById("grades"));
                      }.bind(this)
                    });
                },
                handleAssignmentAdd: function(obj){
                    var d = {
                            assignment_group_id: obj.assignment_group_id,
                            giang_vien_id: this.props.giang_vien,
                            name: obj.name,
                            points: obj.points
                    }
                    $.ajax({
                      url: "/lop/" + this.props.lop + "/assignments",
                      type: 'POST',
                      data: d,
                      success: function(data) {             
                            data.forEach(function(d){
                                if (d.assignments != null && d.assignments.length > 0) {
                                    d.assignments.map(function(d2){
                                        d2.edit = 0;
                                        return d2;
                                    });                                
                                }
                            });        
                            this.setState({data: data, add: 0}); 
                            React.unmountAndReleaseReactRootNode(document.getElementById('grades'));
                            React.renderComponent(<Grade lop={this.props.lop} />,
                                    document.getElementById("grades"));
                      }.bind(this)
                    });
                    return false;
                },
                render: function(){
                    var self = this;
                    var x = this.state.data.map(function(d){
                        return <AssignmentGroup key={d.assignment_group_id} onAssignmentDelete={self.handleAssignmentDelete} onDelete={self.handleDelete} onEdit={self.handleEdit} weight={d.weight} group_name={d.name} onUpdate={self.handleUpdate} group={d.assignment_group_id} data={d.assignments} onAddAssignment={self.handleAssignmentAdd} /> 
                    });
                    if (this.state.add === 0) {
                            return (
                                    <div>
                                    <button class="btn btn-primary btn-sm" onClick={this.enableAdd}>Add</button>
                                    <ul>{x}</ul>       
                                    </div>                         
                            );        
                    } else {
                            return (<div>
                                    <input ref="name" type="text" placeholder="Name" />
                                    <input ref="weight" type="text" placeholder="Weight" />
                                    <button class="btn btn-primary btn-sm" onClick={this.cancelAdd}>Cancel</button>
                                    <button class="btn btn-primary btn-sm" onClick={this.onAdd}>Update</button>
                                    <ul>{x}</ul>
                                    </div>
                            );
                    }
                        
                }
        });
        var AssignmentGroup = React.createClass({
                getInitialState: function(){
                    return {add: 0, edit: 0};
                },
                handleClick: function(){                        
                    this.setState({add: 1, edit: 0});
                },
                handleCancel: function(){                        
                    this.setState({add: 0, edit: 0});
                },        
                handleAdd: function(){                        
                    var name = this.refs.name.getDOMNode().value;
                    var points = this.refs.points.getDOMNode().value;
                    this.setState({add: 0, edit: 0});
                    this.props.onAddAssignment({assignment_group_id: this.props.group, name: name, points: points});
                },
                cancelUpdateName: function(){                        
                    this.setState({edit: 0, add: 0});
                },
                handleUpdateName: function(){                        
                    this.setState({add: 0, edit: 1});
                },
                componentDidUpdate: function(){
                    $('#group' + this.props.group).val(this.props.group_name);
                    $('#weight' + this.props.group).val(this.props.weight);
                },
                handleEdit: function(){
                    var x = this.refs.name.getDOMNode().value;
                    var y = this.refs.weight.getDOMNode().value;
                    this.setState({edit: 0, add: 0});
                    this.props.onEdit({assignment_group_id: this.props.group, name: x, weight: y});                    
                },
                handleDelete: function(e){
                    this.props.onDelete({assignment_group_id: this.props.group});
                },
                render: function(){
                    var self = this;      
                    var x = <li></li>;
                    if (this.props.data != null){
                           x = this.props.data.map(function(d){
                                    return <Assignment group={self.props.group} key={d.assignment_id} data={d} onUpdate={self.props.onUpdate} onDelete={self.props.onAssignmentDelete} />
                            });  
                    }                                 
                    if (this.state.add === 0){
                        if (this.state.edit === 0){
                            return ( 
                                <li>
                                    <span onClick={this.handleUpdateName}>{this.props.group_name}</span>
                                    <span onClick={this.handleWeight}>{this.props.weight}</span>
                                    <button class="btn btn-danger btn-sm" onClick={this.handleDelete}>x</button>
                                    <div>
                                        <button class="btn btn-primary btn-sm" onClick={this.handleClick}>Add</button>
                                        <ul>{x}</ul>
                                    </div>
                                </li>
                            );
                        } else {
                            return (
                                <li>
                                    <div>
                                        <input ref="name" type="text" id={"group" + this.props.group} placeholder="Name" />
                                        <input ref="weight" type="text" id={"weight" + this.props.group} placeholder="Weight" />
                                        <button class="btn btn-primary btn-sm" onClick={this.cancelUpdateName}>Cancel</button>
                                        <button class="btn btn-primary btn-sm" onClick={this.handleEdit}>Update</button>
                                    </div>
                                    <div>
                                        <button class="btn btn-primary btn-sm" onClick={this.handleClick}>Add</button>
                                        <ul>{x}</ul>
                                    </div>
                                </li>
                            );
                        }
                            
                    }
                    else {
                        if (this.state.edit === 0){
                                return (
                                    <li>
                                        <span onClick={this.handleUpdateName}>{this.props.group_name}</span>
                                        <span onClick={this.handleWeight}>{this.props.weight}</span>
                                        <button class="btn btn-danger btn-sm" onClick={this.handleDelete}>x</button>
                                        <div>
                                            <input  ref="name" type="text" placeholder="Name" />
                                            <input  ref="points" type="text" placeholder="points" />
                                            <button class="btn btn-primary btn-sm" onClick={this.handleCancel} >Cancel</button>
                                            <button class="btn btn-primary btn-sm" onClick={this.handleAdd} >Update</button>
                                            <ul>{x}</ul>
                                        </div>
                                    </li>
                                );
                        }
                        else {
                            return (
                                <li>
                                    <div>
                                        <input ref="name" type="text" id={"group" + this.props.group} placeholder="Name" />
                                        <input ref="weight" type="text" id={"weight" + this.props.group} placeholder="Weight" />
                                        <button class="btn btn-primary btn-sm" onClick={this.cancelUpdateName}>Cancel</button>
                                        <button class="btn btn-primary btn-sm" onClick={this.handleEdit}>Update</button>
                                    </div>
                                    <div>
                                        <input  ref="name" type="text" placeholder="Name" />
                                        <input  ref="points" type="text" placeholder="points" />
                                        <button class="btn btn-primary btn-sm" onClick={this.handleCancel} >Cancel</button>
                                        <button class="btn btn-primary btn-sm" onClick={this.handleAdd} >Update</button>
                                        <ul>{x}</ul>
                                    </div>
                                </li>
                            );
                        }
                    }
                }
        });

        var Assignment = React.createClass({                                
            getInitialState: function(){
                return {edit: 0};
            },
            handleEdit: function(e){
                this.setState({edit: 1});
            },
            handleCancelEdit: function(e){
                this.setState({edit: 0});
            },
            handleUpdate: function(e){
                if (this.state.edit === 1) {
                    var name = this.refs.mname.getDOMNode().value;
                    var points = this.refs.mpoints.getDOMNode().value;
                    var d ={assignment_group_id: this.props.group, assignment_id : this.props.data.assignment_id, name: name, points: points};                                        
                    this.setState({edit: 0});
                    this.props.onUpdate(d);
                }                        
            },
            handleDelete: function(e){
                this.props.onDelete({assignment_id: this.props.data.assignment_id});
            },
            componentDidUpdate: function(){                        
                $('#mname' + this.props.data.assignment_id).val(this.props.data.name);
                $('#mpoints' + this.props.data.assignment_id).val(this.props.data.points);
            },
            render: function(){                        
                if (this.state.edit === 1) {
                    return (
                        <li>
                            <input id={"mname" + this.props.data.assignment_id} ref="mname" type="text" />
                            <input id={"mpoints" + this.props.data.assignment_id} ref="mpoints" type="text" />
                            <input class="btn btn-primary btn-sm" onClick={this.handleCancelEdit} type="submit" value="Cancel" />
                            <input class="btn btn-primary btn-sm" onClick={this.handleUpdate} type="submit" value="Update" />
                        </li>
                    )
                } else {
                    return <li><div onClick={this.handleEdit}><span>{this.props.data.name}</span><span>, points: {this.props.data.points}</span>
                    <button class="btn btn-danger btn-sm" onClick={this.handleDelete}>x</button></div></li>                                                
                        
                }                                
            }                
        });
        