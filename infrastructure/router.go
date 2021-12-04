package infrastructure

import (
	"github.com/ITK13201/gin-ent-sample/interfaces/controllers"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func InitRouter() *gin.Engine {
	router := gin.Default()

	ginCfg := cors.DefaultConfig()
	ginCfg.AllowOrigins = []string{"*"}
	router.Use(cors.New(ginCfg))

	sqlClient := NewSqlClient()

	v1 := router.Group("/api/v1")
	{
		user := v1.Group("/users")
		{
			userController := controllers.NewUserController(sqlClient)
			user.POST("", func(c *gin.Context) { userController.Create(c) })
			user.GET(":id", func(c *gin.Context) { userController.GetByID(c) })
			user.GET("", func(c *gin.Context) { userController.GetAll(c) })
			user.PUT(":id", func(c *gin.Context) { userController.Update(c) })
			user.DELETE(":id", func(c *gin.Context) { userController.Delete(c) })
		}

	}

	return router
}
