using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ToDoList
{
    public partial class Default : System.Web.UI.Page
    {
        private List<TaskItem> Tasks
        {
            get
            {
                if (Session["Tasks"] == null)
                {
                    Session["Tasks"] = new List<TaskItem>();
                }
                return (List<TaskItem>)Session["Tasks"];
            }
            set
            {
                Session["Tasks"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Pre-populate due date with today as default
                txtDueDate.Text = DateTime.Today.ToString("yyyy-MM-dd");
                
                // Initialize default sample tasks if empty to give a nice initial impression
                if (Tasks.Count == 0)
                {
                    Tasks.Add(new TaskItem { Id = 1, Title = "Design Dashboard UI", Description = "Create a premium CSS dashboard layout with gradient headers and responsive grid panels.", DueDate = DateTime.Today.AddDays(1), Priority = "High", IsCompleted = false });
                    Tasks.Add(new TaskItem { Id = 2, Title = "Setup Web.config & Routing", Description = "Ensure compilation is targets .NET Framework 4.8 and runs correctly offline.", DueDate = DateTime.Today.AddDays(3), Priority = "Medium", IsCompleted = false });
                    Tasks.Add(new TaskItem { Id = 3, Title = "Review task validation rules", Description = "Verify both client-side and server-side checks function correctly without database dependencies.", DueDate = DateTime.Today, Priority = "Low", IsCompleted = true });
                }

                BindTasks();
            }
        }

        private void BindTasks()
        {
            var taskList = Tasks;

            // Update stats before filtering
            UpdateDashboardStats(taskList);

            // Apply Search filter
            string search = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(search))
            {
                taskList = taskList.Where(t => t.Title.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0).ToList();
            }

            // Apply Priority / Status filter
            string filter = ddlFilter.SelectedValue;
            if (filter != "All")
            {
                if (filter == "Pending")
                {
                    taskList = taskList.Where(t => !t.IsCompleted).ToList();
                }
                else if (filter == "Completed")
                {
                    taskList = taskList.Where(t => t.IsCompleted).ToList();
                }
                else
                {
                    taskList = taskList.Where(t => t.Priority.Equals(filter, StringComparison.OrdinalIgnoreCase)).ToList();
                }
            }

            // Apply Sort
            string sort = ddlSort.SelectedValue;
            if (sort == "Oldest")
            {
                taskList = taskList.OrderBy(t => t.Id).ToList();
            }
            else if (sort == "DueDate")
            {
                taskList = taskList.OrderBy(t => t.DueDate).ToList();
            }
            else if (sort == "Priority")
            {
                taskList = taskList.OrderBy(t => GetPriorityWeight(t.Priority)).ThenBy(t => t.DueDate).ToList();
            }
            else // Default: Newest first
            {
                taskList = taskList.OrderByDescending(t => t.Id).ToList();
            }

            rptTasks.DataSource = taskList;
            rptTasks.DataBind();

            pnlEmptyState.Visible = (taskList.Count == 0);
        }

        private void UpdateDashboardStats(List<TaskItem> allTasks)
        {
            lblTotalTasks.Text = allTasks.Count.ToString();
            lblPendingTasks.Text = allTasks.Count(t => !t.IsCompleted).ToString();
            lblCompletedTasks.Text = allTasks.Count(t => t.IsCompleted).ToString();
            lblHighPriorityTasks.Text = allTasks.Count(t => t.Priority == "High" && !t.IsCompleted).ToString();
        }

        private int GetPriorityWeight(string priority)
        {
            switch (priority)
            {
                case "High": return 1;
                case "Medium": return 2;
                case "Low": return 3;
                default: return 99;
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            // Server-side validation
            string title = txtTitle.Text.Trim();
            if (string.IsNullOrEmpty(title))
            {
                // Force custom validator if required, though RequiredFieldValidator handles it.
                return;
            }

            DateTime dueDate;
            if (!DateTime.TryParse(txtDueDate.Text, out dueDate))
            {
                dueDate = DateTime.Today;
            }

            string priority = ddlPriority.SelectedValue;
            string description = txtDescription.Text.Trim();

            if (string.IsNullOrEmpty(hfTaskId.Value))
            {
                // Add Mode
                int newId = Tasks.Count > 0 ? Tasks.Max(t => t.Id) + 1 : 1;
                var newTask = new TaskItem
                {
                    Id = newId,
                    Title = title,
                    Description = description,
                    DueDate = dueDate,
                    Priority = priority,
                    IsCompleted = false
                };
                Tasks.Add(newTask);
            }
            else
            {
                // Edit Mode
                int id = int.Parse(hfTaskId.Value);
                var existingTask = Tasks.FirstOrDefault(t => t.Id == id);
                if (existingTask != null)
                {
                    existingTask.Title = title;
                    existingTask.Description = description;
                    existingTask.DueDate = dueDate;
                    existingTask.Priority = priority;
                }
            }

            ResetForm();
            BindTasks();
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ResetForm();
        }

        private void ResetForm()
        {
            txtTitle.Text = "";
            txtDescription.Text = "";
            txtDueDate.Text = DateTime.Today.ToString("yyyy-MM-dd");
            ddlPriority.SelectedIndex = 1; // Medium
            hfTaskId.Value = "";
            lblFormTitle.Text = "Create New Task";
            btnSave.Text = "Save Task";
            btnCancel.Visible = false;
        }

        protected void rptTasks_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = int.Parse(e.CommandArgument.ToString());
            var task = Tasks.FirstOrDefault(t => t.Id == id);

            if (e.CommandName == "ToggleComplete" && task != null)
            {
                task.IsCompleted = !task.IsCompleted;
            }
            else if (e.CommandName == "EditTask" && task != null)
            {
                hfTaskId.Value = task.Id.ToString();
                txtTitle.Text = task.Title;
                txtDescription.Text = task.Description;
                txtDueDate.Text = task.DueDate.ToString("yyyy-MM-dd");
                ddlPriority.SelectedValue = task.Priority;
                
                lblFormTitle.Text = "Edit Task";
                btnSave.Text = "Update Task";
                btnCancel.Visible = true;
            }
            else if (e.CommandName == "DeleteTask" && task != null)
            {
                Tasks.Remove(task);
                // If currently editing the deleted task, reset the form
                if (hfTaskId.Value == id.ToString())
                {
                    ResetForm();
                }
            }

            BindTasks();
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            BindTasks();
        }

        protected void ddlFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindTasks();
        }

        protected void ddlSort_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindTasks();
        }

        // Helper helper methods for styles rendering in markup
        protected string GetTaskCardClass(object isCompleted, object priority)
        {
            bool completed = (bool)isCompleted;
            string p = priority.ToString().ToLower();
            string borderClass = p + "-border";
            
            if (completed)
            {
                return $"task-card completed-task {borderClass}";
            }
            return $"task-card {borderClass}";
        }

        protected string GetPriorityBadgeClass(object priority)
        {
            string p = priority.ToString().ToLower();
            return $"badge badge-{p}";
        }

        protected string GetStatusBadgeClass(object isCompleted)
        {
            bool completed = (bool)isCompleted;
            return completed ? "badge badge-completed" : "badge badge-pending";
        }

        protected string GetDueDateClass(object dueDate, object isCompleted)
        {
            DateTime date = (DateTime)dueDate;
            bool completed = (bool)isCompleted;

            if (!completed && date < DateTime.Today)
            {
                return "task-due-date overdue";
            }
            return "task-due-date";
        }

        protected string GetFormattedDescription(object descriptionObj)
        {
            if (descriptionObj == null) return "";
            string desc = descriptionObj.ToString();
            if (string.IsNullOrEmpty(desc))
            {
                return "<em style='color: var(--text-muted);'>No description provided.</em>";
            }
            return HttpUtility.HtmlEncode(desc).Replace("\n", "<br />");
        }
    }
}
