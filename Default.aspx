<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ToDoList.Default" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Modern To-Do List Dashboard</title>
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <!-- Local Stylesheet -->
    <link href="CSS/style.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <header>
            <h1>Task Management Hub</h1>
            <p>Organize, track, and complete your tasks efficiently.</p>
        </header>

        <div class="container">
            <!-- Dashboard / Statistics -->
            <div class="dashboard-grid">
                <div class="stat-card">
                    <div class="stat-icon total">
                        <svg viewBox="0 0 24 24"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-2 10H7v-2h10v2zm0-4H7V7h10v2zm0 8H7v-2h10v2z"/></svg>
                    </div>
                    <div class="stat-info">
                        <asp:Label ID="lblTotalTasks" runat="server" CssClass="stat-value" Text="0"></asp:Label>
                        <span class="stat-label">Total Tasks</span>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon pending">
                        <svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/></svg>
                    </div>
                    <div class="stat-info">
                        <asp:Label ID="lblPendingTasks" runat="server" CssClass="stat-value" Text="0"></asp:Label>
                        <span class="stat-label">Pending</span>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon completed">
                        <svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>
                    </div>
                    <div class="stat-info">
                        <asp:Label ID="lblCompletedTasks" runat="server" CssClass="stat-value" Text="0"></asp:Label>
                        <span class="stat-label">Completed</span>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon high">
                        <svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/></svg>
                    </div>
                    <div class="stat-info">
                        <asp:Label ID="lblHighPriorityTasks" runat="server" CssClass="stat-value" Text="0"></asp:Label>
                        <span class="stat-label">High Priority</span>
                    </div>
                </div>
            </div>

            <!-- Main Workspace Layout -->
            <div class="main-layout">
                <!-- Sidebar Form -->
                <div class="sidebar">
                    <div class="card">
                        <div class="card-header">
                            <h2 class="card-title">
                                <asp:Label ID="lblFormTitle" runat="server" Text="Create New Task"></asp:Label>
                            </h2>
                        </div>
                        <div class="card-body">
                            <!-- Validation Summary -->
                            <asp:ValidationSummary ID="valSummary" runat="server" CssClass="validation-summary" ValidationGroup="TaskGroup" HeaderText="Please fix the following errors:" />
                            
                            <asp:HiddenField ID="hfTaskId" runat="server" />

                            <div class="form-group">
                                <label for="txtTitle">Task Title *</label>
                                <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="What needs to be done?"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle" 
                                    ErrorMessage="Task Title is required." Display="Dynamic" CssClass="val-error" ValidationGroup="TaskGroup"></asp:RequiredFieldValidator>
                            </div>

                            <div class="form-group">
                                <label for="txtDescription">Description</label>
                                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Enter task details..."></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label for="txtDueDate">Due Date</label>
                                <asp:TextBox ID="txtDueDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label for="ddlPriority">Priority</label>
                                <asp:DropDownList ID="ddlPriority" runat="server" CssClass="form-control">
                                    <asp:ListItem Value="High">High</asp:ListItem>
                                    <asp:ListItem Value="Medium" Selected="True">Medium</asp:ListItem>
                                    <asp:ListItem Value="Low">Low</asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="form-group" style="display: flex; gap: 0.5rem; margin-top: 1.5rem;">
                                <asp:Button ID="btnSave" runat="server" Text="Save Task" CssClass="btn btn-primary btn-block" ValidationGroup="TaskGroup" OnClick="btnSave_Click" />
                                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary" Visible="false" OnClick="btnCancel_Click" CausesValidation="false" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Task List Area -->
                <div class="content-area">
                    <!-- Filtering and Sorting Controls -->
                    <div class="controls-bar">
                        <div class="search-box">
                            <svg viewBox="0 0 24 24"><path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/></svg>
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search tasks by title..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
                        </div>
                        
                        <div class="filter-sort-group">
                            <div class="select-wrapper">
                                <span>Filter:</span>
                                <asp:DropDownList ID="ddlFilter" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlFilter_SelectedIndexChanged" style="width: auto;">
                                    <asp:ListItem Value="All">All Tasks</asp:ListItem>
                                    <asp:ListItem Value="Pending">Pending</asp:ListItem>
                                    <asp:ListItem Value="Completed">Completed</asp:ListItem>
                                    <asp:ListItem Value="High">High Priority</asp:ListItem>
                                    <asp:ListItem Value="Medium">Medium Priority</asp:ListItem>
                                    <asp:ListItem Value="Low">Low Priority</asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="select-wrapper">
                                <span>Sort:</span>
                                <asp:DropDownList ID="ddlSort" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlSort_SelectedIndexChanged" style="width: auto;">
                                    <asp:ListItem Value="Newest">Newest First</asp:ListItem>
                                    <asp:ListItem Value="Oldest">Oldest First</asp:ListItem>
                                    <asp:ListItem Value="DueDate">Due Date</asp:ListItem>
                                    <asp:ListItem Value="Priority">Priority</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>

                    <!-- Tasks List Grid -->
                    <div class="tasks-container">
                        <asp:Repeater ID="rptTasks" runat="server" OnItemCommand="rptTasks_ItemCommand">
                            <ItemTemplate>
                                <div class='<%# GetTaskCardClass(Eval("IsCompleted"), Eval("Priority")) %>'>
                                    <div class="task-content">
                                        <div class="task-header">
                                            <h3 class="task-title"><%# HttpUtility.HtmlEncode(Eval("Title")) %></h3>
                                            <div class="badge-container">
                                                <span class='<%# GetPriorityBadgeClass(Eval("Priority")) %>'><%# Eval("Priority") %></span>
                                                <span class='<%# GetStatusBadgeClass(Eval("IsCompleted")) %>'>
                                                    <%# (bool)Eval("IsCompleted") ? "Completed" : "Pending" %>
                                                </span>
                                            </div>
                                        </div>
                                        <div class="task-body" style="margin-top: 0.5rem;">
                                            <%# GetFormattedDescription(Eval("Description")) %>
                                        </div>
                                    </div>
                                    <div class="task-footer">
                                        <div class='<%# GetDueDateClass(Eval("DueDate"), Eval("IsCompleted")) %>'>
                                            <svg viewBox="0 0 24 24"><path d="M19 3h-1V1h-2v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H5V8h14v11zM7 10h5v5H7z"/></svg>
                                            <span><%# ((DateTime)Eval("DueDate")).ToString("yyyy-MM-dd") %></span>
                                        </div>
                                        <div class="task-actions">
                                            <!-- Toggle Complete Button -->
                                            <asp:LinkButton ID="btnToggleComplete" runat="server" CommandName="ToggleComplete" CommandArgument='<%# Eval("Id") %>' 
                                                CssClass='<%# (bool)Eval("IsCompleted") ? "btn btn-secondary btn-icon-only" : "btn btn-success btn-icon-only" %>'
                                                ToolTip='<%# (bool)Eval("IsCompleted") ? "Mark Pending" : "Mark Complete" %>'>
                                                <svg viewBox="0 0 24 24" style="width:16px;height:16px;"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>
                                            </asp:LinkButton>

                                            <!-- Edit Button -->
                                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditTask" CommandArgument='<%# Eval("Id") %>' 
                                                CssClass="btn btn-secondary btn-icon-only" ToolTip="Edit Task">
                                                <svg viewBox="0 0 24 24" style="width:16px;height:16px;"><path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/></svg>
                                            </asp:LinkButton>

                                            <!-- Delete Button -->
                                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteTask" CommandArgument='<%# Eval("Id") %>' 
                                                CssClass="btn btn-danger btn-icon-only" ToolTip="Delete Task"
                                                OnClientClick='<%# "return confirmDelete(\"" + HttpUtility.JavaScriptStringEncode(Eval("Title").ToString()) + "\");" %>'>
                                                <svg viewBox="0 0 24 24" style="width:16px;height:16px;"><path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/></svg>
                                            </asp:LinkButton>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>

                        <!-- Empty State Panel -->
                        <asp:Panel ID="pnlEmptyState" runat="server" CssClass="empty-state">
                            <svg viewBox="0 0 24 24"><path d="M22 16V4c0-1.1-.9-2-2-2H8c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2zm-11-4l2.03 2.71L16 11l4 5H8l3-4zM2 6v14c0 1.1.9 2 2 2h14v-2H4V6H2z"/></svg>
                            <h3>No Tasks Found</h3>
                            <p>Try refining your search/filter parameters or add your first task to get started.</p>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <!-- Local Javascript -->
    <script src="JS/script.js"></script>
</body>
</html>
