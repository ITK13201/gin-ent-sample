package controllers

import (
	"context"
	"strconv"

	"github.com/ITK13201/gin-ent-sample/ent"
	"github.com/gin-gonic/gin"
)

type UserController struct {
	sqlClient *ent.Client
}

func NewUserController(sqlClient *ent.Client) *UserController {
	return &UserController{
		sqlClient: sqlClient,
	}
}

func (controller *UserController) Create(c *gin.Context) {
	ctx := context.Background()

	u := ent.User{}
	err := c.BindJSON(&u)
	if err != nil {
		c.JSON(400, gin.H{
			"error": err.Error(),
		})
		return
	}

	user, err := controller.sqlClient.User.Create().SetUsername(u.Username).SetPassword(u.Password).Save(ctx)
	if err != nil {
		c.JSON(400, gin.H{
			"error": err.Error(),
		})
		return
	}
	c.JSON(201, *user)
}

func (controller *UserController) GetByID(c *gin.Context) {
	ctx := context.Background()
	id64, _ := strconv.ParseInt(c.Param("id"), 10, 64)
	u, err := controller.sqlClient.User.Get(ctx, id64)
	if err != nil {
		c.JSON(400, err)
		return
	}
	c.JSON(200, u)
}

func (controller *UserController) GetAll(c *gin.Context) {
	ctx := context.Background()

	users, err := controller.sqlClient.User.Query().All(ctx)
	if err != nil {
		c.JSON(400, gin.H{
			"error": err.Error(),
		})
		return
	}
	c.JSON(200, users)
}

func (controller *UserController) Update(c *gin.Context) {
	ctx := context.Background()

	id, _ := strconv.Atoi(c.Param("id"))
	id64 := int64(id)

	query := controller.sqlClient.User.UpdateOneID(id64)
	query_flag := false
	username, exists := c.GetQuery("username")
	if exists {
		query = query.SetUsername(username)
		query_flag = true
	}
	password, exists := c.GetQuery("password")
	if exists {
		query = query.SetUsername(password)
		query_flag = true
	}
	if query_flag {
		id, err := query.Save(ctx)
		if err != nil {
			c.JSON(400, gin.H{
				"error": err.Error(),
			})
			return
		}
		c.JSON(201, gin.H{
			"id": id,
		})
	} else {
		c.JSON(400, gin.H{
			"error": "Parameter is missing.",
		})
		return
	}
}

func (controller *UserController) Delete(c *gin.Context) {
	ctx := context.Background()
	id, _ := strconv.Atoi(c.Param("id"))
	id64 := int64(id)

	err := controller.sqlClient.User.DeleteOneID(id64).Exec(ctx)
	if err != nil {
		c.JSON(400, err)
		return
	}
	c.JSON(200, gin.H{
		"id": id64,
	})
}
