 /** @jsx React.DOM */
        
        var DATA = [
                {assignment_group_id: 1, name: 'BT1', weight: 50, assignments:
                                [
                                        {assignment_id: 1, name: 'BT11', score: 10},
                                        {assignment_id: 2,name: 'BT12', score: 8}
                                ]
                },
                {assignment_group_id: 2, name: 'BT2', weight: 50, assignments:
                                [
                                        {assignment_id: 3, name: 'BT21', score: 9},
                                        {assignment_id: 4,name: 'BT22', score: 8}
                                ]}
                ];
        var Assignments = React.createClass({
                getInitialState: function(){
                        return {data: [], add: 0};                        
                },
                handleChange: function(obj){
                        var x = this.state.data.filter(function(t){
                                return t.assignment_group_id === obj.assignment_group_id;
                        });
                        if (x.length > 0) {
                                var y = x[0];
                                if (y != null) {
                                        y.assignments.push({name: obj.name, score: obj.score});
                                        this.forceUpdate();        
                                }
                        }
                },
                findGroup: function(assignment_group_id){
                        var x = this.state.data.filter(function(t){
                                return t.assignment_group_id === assignment_group_id;
                        });
                        if (x.length > 0) {
                                return x[0];
                        }
                        return null;
                },
                findAssignment: function(assignment_group_id, assignment_id){
                        var x = this.state.data.filter(function(t){
                                return t.assignment_group_id === assignment_group_id;
                        });
                        
                        if (x.length > 0) {
                                var z = x.assignments.filter(function(t){
                                        return t.assignment_id === assignment_id;
                                });
                                var y = z[0];
                                if (y != null) {
                                        return y;
                                }
                        }                                
                        return null;
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
                            }.bind(this)
                        });             
                },
                componentWillMount: function(){
                        this.loadData();
                },
                
                handleEdit: function(obj){
                        var group = this.findGroup(obj.id);
                        if (group != null) {
                                group.name = obj.name;
                                group.weight = obj.weight;
                                this.forceUpdate();
                        }
                },
                handleUpdate: function(d){
                        var a = this.findAssignment(d.assignment_group_id, d.assignment_id);
                        if (a != null) {
                                a.name = d.name;
                                a.score = d.score;                                                                
                                this.forceUpdate();
                        }
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
                          }.bind(this)
                        });
                        return false;
                },
                render: function(){
                        var self = this;
                        var x = this.state.data.map(function(d){
                            return <AssignmentGroup onEdit={self.handleEdit} weight={d.weight} group_name={d.name} onUpdate={self.handleUpdate} group={d.assignment_group_id} onChange={self.handleChange} data={d.assignments} /> 
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
                handleUpdate: function(){                        
                        var name = this.refs.name.getDOMNode().value;
                        var score = this.refs.score.getDOMNode().value;
                        this.setState({add: 0, edit: 0});
                        this.props.onChange({assignment_group_id: this.props.group, name: name, score: score});
                },
                handleChange: function(e){
                        var name = this.refs.name.getDOMNode().value;
                        var score = this.refs.score.getDOMNode().value;
                        this.setState({name: name, score: score});
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
                        this.props.onEdit({id: this.props.group, name: x, weight: y});
                        this.setState({edit: 0, add: 0});
                },
                render: function(){
                        var self = this;      
                        var x = <li></li>;
                        if (this.props.data != null){
                               x = this.props.data.map(function(d){
                                        return <Assignment data={d} onUpdate={self.props.onUpdate} />
                                });  
                        }                                 
                        if (this.state.add === 0){
                                if (this.state.edit === 0){
                                        return ( <li>
                                                <span onClick={this.handleUpdateName}>{this.props.group_name}</span>
                                                <span onClick={this.handleWeight}>{this.props.weight}</span>
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
                                                <div>
                                                        <input onChange={this.handleChange} ref="name" type="text" placeholder="Name" />
                                                        <input onChange={this.handleChange} ref="score" type="text" placeholder="Score" />
                                                        <button class="btn btn-primary btn-sm" onClick={this.handleCancel} >Cancel</button>
                                                        <button class="btn btn-primary btn-sm" onClick={this.handleUpdate} >Update</button>
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
                                                        <input onChange={this.handleChange} ref="name" type="text" placeholder="Name" />
                                                        <input onChange={this.handleChange} ref="score" type="text" placeholder="Score" />
                                                        <button class="btn btn-primary btn-sm" onClick={this.handleCancel} >Cancel</button>
                                                        <button class="btn btn-primary btn-sm" onClick={this.handleUpdate} >Update</button>                                                        
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
                                this.props.data.name = this.refs.mname.getDOMNode().value;
                                this.props.data.score = this.refs.mscore.getDOMNode().value;                        
                                this.setState({edit: 0});
                                this.props.onUpdate(this.props.data);
                        }                        
                },
                componentDidUpdate: function(){                        
                        $('#mname' + this.props.data.assignment_id).val(this.props.data.name);
                        $('#mscore' + this.props.data.assignment_id).val(this.props.data.score);                                                        
                },
                render: function(){                        
                        if (this.state.edit === 1) {
                                return (
                                        <li>
                                                <input id={"mname" + this.props.data.assignment_id} ref="mname" type="text" />
                                                <input id={"mscore" + this.props.data.assignment_id} ref="mscore" type="text" />
                                                <input class="btn btn-primary btn-sm" onClick={this.handleCancelEdit} type="submit" value="Cancel" />
                                                <input class="btn btn-primary btn-sm" onClick={this.handleUpdate} type="submit" value="Update" />
                                        </li>
                                )
                        } else {
                                return <li><div onClick={this.handleEdit}>{this.props.data.name}, score: {this.props.data.score}</div></li>                                                
                                
                        }                                
                }                
        });
        